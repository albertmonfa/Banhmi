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

import json
from aiohttp.web import Response
from aiohttp.web import middleware
from aiohttp.web import HTTPException, HTTPNotFound

from core.base.GlobalRegistry import GlobalRegistry

class Logging(object):

    @middleware
    async def hook(request, handler):
        GR = GlobalRegistry()
        logger = GR.get('logger')

        try:
            response = await handler(request)

            msg = '{} {} {} - {} {}'.format(
                request.remote,
                request.method,
                request.url,
                response.status,
                response.content_type,
            )

            if response.status in [400,404,409]:
                try:
                    msg = '{} {}'.format(msg, json.loads(response.body))
                    logger.warning(msg)
                except Exception as e:
                    msg = '{} {}'.format(msg, 'No JSON Content')
                    logger.warning(msg)
            elif response.status in [500]:
                try:
                    msg = '{} {}'.format(msg, json.loads(response.body))
                    logger.error(msg)
                except Exception as e:
                    msg = '{} {}'.format(msg, 'No JSON Content')
                    logger.error(msg)
            else:
                logger.debug(msg)

            return response

        except HTTPNotFound as ex:
            print(ex.reason)
            response = Response(
                status=404,
            )
            return response

        except HTTPException as ex:
            response = Response(
                status=501,
                reason='Not Implemented',
            )
            return response