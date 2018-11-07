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

from aiohttp.web import StreamResponse

class HandlerBase(object):

    _route_regex    = None

    def __init__(self, route_regex):
        self._route_regex = route_regex

    def get_route_regex(self):
        return self._route_regex

    async def on_prepare(self, request, response):
        response.headers['Server'] = '{}/{}'.format(request.app['app_name'],request.app['app_version'])
        response.headers['X-Zalora'] = 'aHR0cHM6Ly93d3cubGlua2VkaW4uY29tL2luL2FsYmVydG1vbmZhLw'

    async def get(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response

    async def head(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response

    async def post(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response

    async def put(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response

    async def delete(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response

    async def connect(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response

    async def options(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response

    async def trace(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response

    async def patch(self, request):
        response = StreamResponse(
            status=501,
            reason='Not Implemented',
            )
        await response.prepare(request)
        return response
