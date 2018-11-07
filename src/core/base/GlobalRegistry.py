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


class Singleton(type):
    _instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).\
                __call__(*args, **kwargs)
        return cls._instances[cls]

class GlobalRegistry(object):
    __metaclass__ = Singleton

    __registry__ = dict()

    def add(self, key, value):
        if self.exist(key):
            return False
        self.__registry__[key] = value
        return True

    def delete(self, key):
        if self.exist(key):
            del self.__registry__[key]
            return True
        return False

    def update(self, key, value):
        if self.exist(key):
            self.__registry__[key] = value
            return True
        return False

    def exist(self, key):
        if key in self.__registry__:
            return True
        return False

    def get(self, key):
        if self.exist(key):
            return self.__registry__[key]
        return None

    def getAll(self):
        return self.__registry__
