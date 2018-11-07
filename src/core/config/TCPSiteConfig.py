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

class TCPSiteConfig(object):

    __name__ = None

    def __init__(self, cfg):
        self.__cfg = cfg

    def get_host(self):
        return self.__cfg['server']['host']

    def get_port(self):
        return self.__cfg['server']['port']

    def get_shutdown_timeout(self):
        return self.__cfg['server']['shutdown_timeout']

    def get_backlog(self):
        return self.__cfg['server']['backlog']

    def get_reuse_address(self):
        return self.__cfg['server']['reuse_address']

    def get_reuse_port(self):
        return self.__cfg['server']['reuse_port']