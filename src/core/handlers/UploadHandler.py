#!/usr/bin/python
'''
Copyright 2018 Albert Monfa

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
'''

import aiobotocore
import botocore
import aiohttp
import hashlib
import CommonREST
from json import dumps
from aiohttp.hdrs import CONTENT_TYPE
from jsonschema import validate, ValidationError

from core.server.HandlerBase import  HandlerBase

class UploadHandler(HandlerBase):

    md_file_sch = {
        "type": "object",
        "required": ["bucket", "key", "size","parts"],
        "properties": {
            "bucket": {"type": "string"},
            "key": {"type": "string"},
            "size": {"type": "number"},
            "parts": {"type": "number"},
            "mpu_id": {"type": "string"},
            "last_part": {"type": "number"},
        },
        "additionalProperties": False
    }

    def __init__(self):
        super().__init__(r'/file/{name:upload}')

    async def md_parser(self, metadata_future):
        if metadata_future is None:
            return CommonREST.gen_response_error('JSON Request expected Not Found')

        if metadata_future.headers[CONTENT_TYPE] == 'application/json':
            metadata_json = await metadata_future.json()
            try:
                validate(metadata_json, self.md_file_sch)
                return CommonREST.gen_response_success(metadata_json)
            except ValidationError as validation_err:
                return CommonREST.gen_response_error(str(validation_err.message))

    async def bucket_exist(self, aws_session, settings):
        async with aws_session.create_client(
                's3', region_name=self.__request.app['aws_region'],
                endpoint_url=self.__request.app['s3_endpoint_url']) as s3_client:
            try:
                response = await s3_client.head_bucket(
                    Bucket=settings['bucket']
                )
                return True
            except botocore.exceptions.ClientError as e:
                return False

    async def object_exist(self, aws_session, settings):
        async with aws_session.create_client(
                's3', region_name=self.__request.app['aws_region'],
                endpoint_url=self.__request.app['s3_endpoint_url']) as s3_client:
            try:
                response = await s3_client.head_object(Bucket=settings['bucket'], Key=settings['key'])
                return dumps(response, default=CommonREST.json_serial)
            except botocore.exceptions.ClientError as e:
                return None

    async def create_mp_upload(self, aws_session, settings):
        async with aws_session.create_client(
                's3', region_name=self.__request.app['aws_region'],
                endpoint_url=self.__request.app['s3_endpoint_url']) as s3_client:
            try:
                aws_response = await s3_client.create_multipart_upload(
                    Bucket=settings['bucket'], Key=settings['key']
                )
                return CommonREST.gen_response_success(aws_response["UploadId"])
            except botocore.exceptions.ClientError as e:
                return CommonREST.gen_response_error(str(e.message))

    async def complete_mp_upload(self, aws_session, settings, mpu_id, uploaded_parts):
        async with aws_session.create_client(
                's3', region_name=self.__request.app['aws_region'],
                endpoint_url=self.__request.app['s3_endpoint_url']) as s3_client:
            try:
                aws_response = await s3_client.complete_multipart_upload(
                    Bucket=settings['bucket'], Key=settings['key'], UploadId=mpu_id,
                    MultipartUpload={ 'Parts': uploaded_parts }
                )
                return CommonREST.gen_response_success(aws_response)
            except botocore.exceptions.ClientError as e:
                return CommonREST.gen_response_error(str(e))

    async def upload_mp_chunk(self, aws_session, settings, raw_data_part, mpu_id, part_num):
        async with aws_session.create_client(
                's3', region_name=self.__request.app['aws_region'],
                endpoint_url=self.__request.app['s3_endpoint_url']) as s3_client:
            try:
                aws_response = await s3_client.upload_part(
                    Bucket=settings['bucket'], Key=settings['key'], UploadId=mpu_id,
                    PartNumber=part_num, Body=raw_data_part
                )
                return CommonREST.gen_response_success(aws_response)
            except botocore.exceptions.ClientError as e:
                return CommonREST.gen_response_error(str(e))

    async def post(self, request):
        self.__request = request
        uploaded_parts = list()
        aws_session = aiobotocore.get_session()
        mp_reader = await request.multipart()
        metadata_future = await mp_reader.next()
        settings = await self.md_parser(metadata_future)
        settings['payload']['key'] = hashlib.sha224(settings['payload']['key'].encode('utf-8')).hexdigest()

        if settings['status'] is not 'success':
            return aiohttp.web.json_response(data=settings, status=400)

        if not await self.bucket_exist(aws_session, settings['payload']):
            response_obj = {'status': 'error', 'msg': 'Bucket do not exist.'}
            return aiohttp.web.json_response(data=response_obj, status=400)

        aws_response = await self.object_exist(aws_session, settings['payload'])
        if aws_response is not None:
            response_obj = {'status': 'error', 'msg': 'Object already exist in the bucket', 'aws_response': aws_response}
            return aiohttp.web.json_response(data=response_obj, status=409)

        mpu_id_response = await self.create_mp_upload(aws_session, settings['payload'])
        if mpu_id_response['status'] is not 'success':
            return aiohttp.web.json_response(data=mpu_id_response, status=500)
        mpu_id = mpu_id_response['payload']

        for offset in range(settings['payload']['parts'] + 1):
            mp_chunk = await mp_reader.next()
            if mp_chunk is None:
                mpu_complete_resp = await self.complete_mp_upload(
                    aws_session,
                    settings['payload'],
                    mpu_id,
                    uploaded_parts
                )
                if mpu_complete_resp['status'] is not 'success':
                    return aiohttp.web.json_response(data=mpu_complete_resp, status=500)
                return aiohttp.web.json_response(data=mpu_complete_resp, status=200)
                break
            raw_data_part = await mp_chunk.read()
            mpu_upload_response = await self.upload_mp_chunk(
                aws_session,
                settings['payload'],
                raw_data_part, mpu_id, offset + 1
            )
            if mpu_upload_response['status'] is not 'success':
                return aiohttp.web.json_response(data=mpu_upload_response, status=409)

            uploaded_parts.append(
                {
                    'ETag': str(mpu_upload_response['payload']['ETag']),
                    'PartNumber': int(offset + 1)
                }
            )
        return aiohttp.web.json_response(
            data=CommonREST.gen_response_error('Still receiving data after the last part received'),
            status=500
        )