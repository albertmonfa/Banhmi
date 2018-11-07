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

from aiohttp.web import TCPSite
from core.base.GlobalRegistry import GlobalRegistry

class SiteFactory(object):

    GR = GlobalRegistry()

    def __init__(self, runner, config):
        self.__config = config
        self.__runner = runner
        self.logger = self.GR.get('logger')

    def buildSite(self):
        self.__site = TCPSite(
            self.__runner,
            host=self.__config.get_host(),
            port=self.__config.get_port(),
            shutdown_timeout=int(float(self.__config.get_shutdown_timeout())),
            backlog=self.__config.get_backlog(),
            reuse_address=self.__config.get_reuse_address(),
            reuse_port=self.__config.get_reuse_port()
        )
        self.logger.log(1000,'TCPSite Listening on {}:{}'.format(
            self.__config.get_host(),
            self.__config.get_port()
            )
        )

    def getSite(self):
        return self.__site