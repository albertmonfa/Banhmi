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

class ObjectBase(object):

    __name__ = None

    def __str__(self):
        result = dict()
        for var in vars(self).keys():
            if callable(vars(self)[var]):
                result[var] = vars(self)[var]
                continue
            result[var] = str(vars(self)[var])
        return str(result)
