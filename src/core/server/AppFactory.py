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


from aiohttp.web import Application

from core.base.GlobalRegistry import GlobalRegistry
from core.server.RoutesBuilder import  RoutesBuilder
from core.server.HandlerBase import  HandlerBase
from core.handlers.UploadHandler import  UploadHandler
from core.handlers.DownloadHandler import  DownloadHandler
from core.handlers.DeleteHandler import  DeleteHandler
from core.handlers.StatusHandler import  StatusHandler
from core.handlers.HealthcheckHandler import  HealthcheckHandler
from core.middleware.Authentication import Authentication
from core.middleware.Logging import Logging
from core.middleware.Common import Common

class AppFactory(object):

    GR = GlobalRegistry()

    def __init__(self, config):
        self.__config = config
        self.__base_handler = HandlerBase(r'/')
        self.__upload_handler = UploadHandler()
        self.__download_handler = DownloadHandler()
        self.__delete_handler = DeleteHandler()
        self.__status_handler = StatusHandler()
        self.__healthcheck_handler = HealthcheckHandler()
        self.logger = self.GR.get('logger')

    def buildApp(self):
        self.__app = Application(
            debug=self.__config.get_debug(),
            client_max_size=self.__config.get_client_max_size(),
            middlewares = [
                Authentication.hook,
                Logging.hook,
                Common.hook
            ]
        )
        self.logger.debug('Generating RoutesBuilder for the Upload Handler')
        self.__app.on_response_prepare.append(self.__upload_handler.on_prepare)
        self.__rb_upload = RoutesBuilder(self.__app, self.__upload_handler)

        self.logger.debug('Generating RoutesBuilder for the Download Handler')
        self.__app.on_response_prepare.append(self.__download_handler.on_prepare)
        self.__rb_download = RoutesBuilder(self.__app, self.__download_handler)

        self.logger.debug('Generating RoutesBuilder for the Delete Handler')
        self.__app.on_response_prepare.append(self.__delete_handler.on_prepare)
        self.__rb_delete = RoutesBuilder(self.__app, self.__delete_handler)

        self.logger.debug('Generating RoutesBuilder for the Status Handler')
        self.__app.on_response_prepare.append(self.__status_handler.on_prepare)
        self.__rb_status = RoutesBuilder(self.__app, self.__status_handler)

        self.logger.debug('Generating RoutesBuilder for the Healthcheck Handler')
        self.__app.on_response_prepare.append(self.__healthcheck_handler.on_prepare)
        self.__rb_healthcheck = RoutesBuilder(self.__app, self.__healthcheck_handler)

        self.__app['aws_region'] = self.__config.get_aws_region()
        self.__app['s3_endpoint_url'] = self.__config.get_s3_endpoint_url()
        self.__app['app_name'] = self.__config.get_app_name()
        self.__app['app_version'] = self.__config.get_app_version()

    def getApp(self):
        return self.__app
