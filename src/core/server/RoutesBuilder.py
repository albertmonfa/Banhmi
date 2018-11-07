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

#import ast
import inspect
from enum import Enum
#from aiohttp import web

from core.base.ObjectBase import ObjectBase


class HTTPMethods(Enum):
    GET = 'get'
    HEAD = 'head'
    POST = 'post'
    PUT = 'put'
    DELETE = 'delete'
    CONNECT = 'connect'
    OPTIONS = 'options'
    TRACE = 'trace'
    PATCH = 'patch'


class RoutesBuilder(ObjectBase):
    __app = None
    __handler = None

    __methods = [meth.value for meth in HTTPMethods]

    def __init__(self, app, handler):
        self.__handler = handler
        self.__app = app
        self.__autobuilder()

    def __add_route(self, method):
        if inspect.iscoroutinefunction(method[1]) \
                and method[0] in self.__methods:
            self.__app.router.add_route(
                method[0].upper(),
                self.__handler.get_route_regex(),
                method[1]
            )

    def __autobuilder(self):
        for method in inspect.getmembers(self.__handler):
            self.__add_route(method)
