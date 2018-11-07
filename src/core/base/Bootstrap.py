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

import sys
import yaml
import logging
import logging.handlers
from docopt import docopt
from jsonschema import validate, ValidationError

from core.base.Logging import Logging
from core.base.GlobalRegistry import GlobalRegistry
from core.config.AppConfig import AppConfig
from core.config.RunnerConfig import RunnerConfig
from core.config.TCPSiteConfig import TCPSiteConfig
from core.server.HTTPServer import HTTPServer


doc = \
'''
This project is designed as an approach for the technical test
received by Zalora company for the "Senior Systems Engineer"
application. It is just a POC but the approach could be used as
base for a real world implementations.

Banhmi uses the config file "banhmi.yml" to overwrite the default
configuration parameters.

Usage:
  banhmi [--config=<file>]
  banhmi (-h | --help)

Options:
  -h --help                    Show this screen
  -c --config=<file>           Config file [default: /etc/banhmi/banhmi.yml]

BanhMi, Technical Test for Zalora - Copyright 2018 Albert Monfa.
This Software is released under Apache License, Version 2.0.
'''

def constant(f):
    def fset(self, value):
        raise TypeError
    def fget(self):
        return f()
    return property(fget, fset)

class _Const(object):
    @constant
    def APP_NAME():
        return 'Banhmi'

    @constant
    def APP_VERSION():
        return '1.0'


class Bootstrap(object):

    GR = GlobalRegistry()

    def init_cli(self):
        CONST = _Const()
        self.__cli_args = docopt(doc=doc, version='{0}/{1}'.format(CONST.APP_NAME,CONST.APP_VERSION), options_first=True)

    def init_config(self):
        CONST = _Const()
        try:
            import inspect, os
            base = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
            with open('{}/../config/schemas/main.yml'.format(base)) as json_file:
                main_sch = yaml.load(json_file)
            with open(self.__cli_args['--config'], 'r') as yml_file:
                self.__cfg = yaml.load(yml_file)
                validate(self.__cfg, main_sch)
                self.__cfg['global']['app_name'] = CONST.APP_NAME
                self.__cfg['global']['app_version'] = CONST.APP_VERSION
                self.GR.add('log_level', self.__cfg['global']['log_level'])
        except ValidationError as e:
            self.__logger.fatal('Error yaml validation: {}'.format(str(e.message)))
            self.__logger.fatal('Error loading yaml file config, it seems broken or missing! file: {}'.format(
                str(self.__cli_args['--config'])))
            sys.exit(1)

    def init_logging_system(self):
        level = Logging.severity(self.__cfg['global']['log_level'])
        self.__logger = logging.getLogger(__name__)
        self.__logger.setLevel(level)
        ch = logging.StreamHandler(sys.stdout)
        ch.setLevel(level)
        formatter = logging.Formatter('%(asctime)s -  %(levelname)s - %(message)s')
        ch.setFormatter(formatter)
        self.__logger.addHandler(ch)
        self.GR.add('logger', self.get_logger())
        self.__logger.log(1000,'Starting {}/{} Running on {} AWS Region'.format(
            self.__cfg['global']['app_name'],
            self.__cfg['global']['app_version'],
            self.__cfg['global']['aws_region'],
            )
        )

    def banhmin_server(self):
        self.__logger.debug('Generating AppConfig')
        app_config = AppConfig(self.__cfg)
        self.__logger.debug('Generating RunnerConfig')
        runner_config = RunnerConfig(self.__cfg)
        self.__logger.debug('Generating SiteConfig')
        site_config = TCPSiteConfig(self.__cfg)
        self.__logger.debug('Generating HTTPServer')
        return HTTPServer(app_config, runner_config, site_config)

    def get_logger(self):
        return self.__logger

    def get_cli_args(self):
        return self.__cli_args

    def get_cfg(self):
        return self.__cfg
