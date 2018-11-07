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

import asyncio
from core.base.GlobalRegistry import GlobalRegistry
from core.base.Logging import Logging
from core.server.AppFactory import  AppFactory
from core.server.SiteFactory import  SiteFactory
from core.server.RunnerFactory import  RunnerFactory
from core.base.ObjectBase import ObjectBase

class HTTPServer(ObjectBase):

    GR = GlobalRegistry()

    def __init__(self, app_config, runner_config, site_config):
        self.__app_config = app_config
        self.__runner_config = runner_config
        self.__site_config = site_config
        self.logger = self.GR.get('logger')

    async def start(self):
        self.logger.info('Starting HTTP Server')
        self.__app_fact = AppFactory(self.__app_config)
        self.__app_fact.buildApp()

        self.__runner_fact = RunnerFactory(
            self.__app_fact.getApp(),
            self.__runner_config
        )
        self.__runner_fact.buildRunner()
        await self.__runner_fact.getRunner().setup()

        self.__site_fact = SiteFactory(
            self.__runner_fact.getRunner(),
            self.__site_config
        )
        self.__site_fact.buildSite()
        await self.__site_fact.getSite().start()

    async def shutdown(self):
        self.logger.info('Stopping HTTP Server')
        await self.__site_fact.getSite().stop()
        await self.__app_fact.getApp().cleanup()

    def get_app(self):
        return self.__app

    def get_runner(self):
        return self.__runner

    def get_site(self):
        return self.__site

    def get_event_loop(self):
        return asyncio.get_event_loop()
