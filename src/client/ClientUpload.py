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
import asyncio
import os
import math


MAX_SIZE_PER_PART = 5242880
URL_PATTERN = '{0}/file/upload?bucket={1}&key={2}'

class ClientUpload():

    metadata = { 'key': None, 'bucket': None, 'size': None, 'parts': None }

    def __init__(self, max_size_per_part=MAX_SIZE_PER_PART):
        self.max_size_per_part = max_size_per_part

    def __getFileSize(self, filename):
        st = os.stat(filename)
        return st.st_size

    def __gen_metadata_mp_uploader(self, bucket, key, path):
        self.metadata['bucket'] = bucket
        self.metadata['key'] = key
        self.metadata['size'] = self.__getFileSize(path)
        if self.metadata['size'] < MAX_SIZE_PER_PART:
            self.metadata['parts'] = 1
        else:
            self.metadata['parts'] = int(math.ceil(self.metadata['size'] / MAX_SIZE_PER_PART))
        return self.metadata


    def mp_upload(self, bucket, key, host, path):
        return self.upload(bucket, key, host, path, mp_upload=True)


    def upload(self, bucket, key, host, path, mp_upload=False):
        url = str(URL_PATTERN).format(host, bucket, key)

        async def uploader():
            self.session = aiohttp.ClientSession()
            if mp_upload:
                resp = await self.__mp_uploader(
                    url,
                    path,
                    self.__gen_metadata_mp_uploader(bucket, key, path)
                )
                await self.session.close()
                return resp
            else:
                return None

        loop = asyncio.get_event_loop()
        resp = loop.run_until_complete(uploader())
        return resp


    async def __mp_uploader(self, url, path, metadata):
        file = open(path, 'rb')
        with aiohttp.MultipartWriter('mixed') as mpwriter:
            mpwriter.append_json(metadata)
            for part in range(metadata['parts']):
                file.seek(file.tell(), 0)
                data = file.read(MAX_SIZE_PER_PART)
                mpwriter.append(data)
            resp = await self.session.post(url, data=mpwriter)
            return resp
