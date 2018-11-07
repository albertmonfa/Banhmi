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

import logging

class Logging():

    __severity = {
        0 : logging.DEBUG,
        1 : logging.INFO,
        2 : logging.WARNING,
        3 : logging.ERROR,
        4 : logging.CRITICAL
    }

    def severity(log_level):
        if log_level not in range(0,4):
            return logging.ERROR
        return Logging.__severity[log_level]
