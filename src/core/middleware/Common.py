#!/usr/bin/python
'''
Author: Albert Monfa

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

from aiohttp.web import json_response
from aiohttp.web import Response
from aiohttp.web import middleware
from aiohttp.web import HTTPException, HTTPNotFound

class Common(object):

    @middleware
    async def hook(request, handler):
        try:
            response = await handler(request)
            return response

        except HTTPNotFound as ex:
            response_obj = {'status': 'error', 'payload': 'Resource not found'}
            return json_response(data=response_obj, status=404)

        except HTTPException as ex:
            response = Response(
                status=501,
                reason='Not Implemented',
            )

        except Exception as ex:
             response_obj = {'status': 'error', 'payload': str(ex)}
             return json_response(data=response_obj, status=500)

        return response
