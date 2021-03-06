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

import aiohttp
import aiobotocore
import botocore
import hashlib
import CommonREST
from aiohttp.web import  json_response
from core.server.HandlerBase import  HandlerBase
from core.base.GlobalRegistry import GlobalRegistry

class DeleteHandler(HandlerBase):

    GR = GlobalRegistry()

    def __init__(self):
        super().__init__(r'/file/{name:delete}')
        self.logger = self.GR.get('logger')

    async def delete(self, request):
        if not self.__validate_query(request.query):
            response_obj = {'status': 'fail','msg' : 'Wrong query parameters, bucket and key is mandatory'}
            return json_response(data=response_obj, status=404)

        s3_key_name = hashlib.sha224(request.query['key'].encode('utf-8')).hexdigest()
        aws_session = aiobotocore.get_session()
        async with aws_session.create_client(
                's3', region_name=request.app['aws_region'],
                endpoint_url=request.app['s3_endpoint_url']) as s3_client:
            try:
                response = await s3_client.delete_object(Bucket=request.query['bucket'], Key=s3_key_name)
                print(response)
                return aiohttp.web.json_response(
                    data=CommonREST.gen_response_success(response),
                    status=204
                )
            except botocore.exceptions.ClientError as e:
                return aiohttp.web.json_response(
                    data=CommonREST.gen_response_error(str(e)),
                    status=404
                )

    def __validate_query(self, query):
        if 'bucket' not in query.keys():
            return False
        if 'key' not in query.keys():
            return False
        return True