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

class RunnerConfig(object):

    __name__ = None

    def __init__(self, cfg):
        self.__cfg = cfg

    def get_make_handler_params(self):
        config = dict()
        config['tcp_keepalive'] = self.__cfg['server']['tcp_keepalive']
        config['keepalive_timeout'] = self.__cfg['server']['keepalive_timeout']
        config['max_line_size'] = self.__cfg['server']['max_line_size']
        config['max_headers'] = self.__cfg['server']['max_headers']
        config['max_field_size'] = self.__cfg['server']['max_field_size']
        config['lingering_time'] = self.__cfg['server']['lingering_time']
        return config