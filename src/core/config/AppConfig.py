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

class AppConfig(object):

    __name__ = None

    def __init__(self, cfg):
        self.__cfg = cfg

    def get_app_name(self):
        return self.__cfg['global']['app_name']

    def get_app_version(self):
        return self.__cfg['global']['app_version']

    def get_debug(self):
        return self.__cfg['server']['debug']

    def get_client_max_size(self):
        return self.__cfg['server']['client_max_size']

    def get_aws_region(self):
        return self.__cfg['global']['aws_region']

    def get_s3_endpoint_url(self):
        return self.__cfg['global']['s3_endpoint_url']