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
import os
import inspect
import logging
import hashlib
import aiobotocore
from multiprocessing import Process
from aiohttp.test_utils import TestClient, TestServer, loop_context

sys.path.append('{}/../'.format(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))))
from core.config.AppConfig import AppConfig
from core.server.AppFactory import  AppFactory
from core.base.GlobalRegistry import GlobalRegistry

sys.path.append('{}/../client/'.format(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))))
from ClientDownload import ClientDownload
from ClientStatus import ClientStatus
from ClientDelete import ClientDelete
from ClientUpload import ClientUpload


#### VARS ###
os.environ["AWS_ACCESS_KEY_ID"] = "foobar" # FAKE
os.environ["AWS_SECRET_ACCESS_KEY"] = "foobar" #FAKE
s3_endpoint_url = 'http://localstack:5000'
bucket = 'net.telenix.zalora'
key = 'foo'
local_file_downloaded = '/tmp/output.dat.download'
local_file_path='/tmp/output.dat'
region='us-east-1'


def _generate_logger():
    root = logging.getLogger()
    root.setLevel(logging.INFO)
    ch = logging.StreamHandler(sys.stdout)
    ch.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    root.addHandler(ch)
    GR.add('logger', root)


def _generate_cfg():
    cfg = dict()
    cfg['global'] = dict()
    cfg['server'] = dict()
    cfg['global']['app_name'] = 'Banhmi'
    cfg['global']['app_version'] = 'TEST'
    cfg['server']['debug'] = False
    cfg['server']['client_max_size'] = 104857600
    cfg['global']['aws_region'] = region
    cfg['global']['s3_endpoint_url'] = s3_endpoint_url
    return cfg


def _test_app():
    _generate_logger()
    app_config = AppConfig(_generate_cfg())
    app_fact = AppFactory(app_config)
    app_fact.buildApp()
    app = app_fact.getApp()
    return app

def _hash_file(path):
    hasher = hashlib.md5()
    with open(path, 'rb') as afile:
        buf = afile.read()
        hasher.update(buf)
    return hasher.hexdigest()

with loop_context() as loop:
    GR = GlobalRegistry()
    app = _test_app()
    client = TestClient(TestServer(app), loop=loop)
    loop.run_until_complete(client.start_server())
    root = "http://127.0.0.1:{}".format(client.port)
    logger = GR.get('logger')

    def runner(target):
        p_upload_test = Process(target=target)
        p_upload_test.start()
        p_upload_test.join()

    def create_bucket():
        try:
            import botocore.session
            aws_session = botocore.session.get_session()
            s3_client = aws_session.create_client('s3', region_name=region,
                    endpoint_url=s3_endpoint_url
                    )
            response = s3_client.create_bucket(Bucket=bucket)
            logger.info('BUCKET {} CREATED: {}'.format(bucket,response))
        except Exception as e:
            logger.error('ERROR Creating Bucket: {}'.format(str(e)))
            loop.run_until_complete(client.close())
            sys.exit(-1)

    def test_mp_upload():
        with open(local_file_path, "wb") as out:
            out.truncate(1024 * 1024)
        cu = ClientUpload()
        resp1 = cu.mp_upload(bucket, key, root, local_file_path)
        assert resp1.status == 200
        resp2 = cu.mp_upload(bucket, key, root, local_file_path)
        assert resp2.status == 409

    def test_download():
        cd = ClientDownload()
        resp = cd.download(bucket, key, root, local_file_downloaded)
        assert resp.status == 206
        hash_original =  _hash_file(local_file_path)
        hash_downloaded = _hash_file(local_file_downloaded)
        assert hash_original == hash_downloaded

    def test_status():
        cs = ClientStatus()
        resp = cs.status(bucket, key, root)
        print(resp)
        assert resp.status == 200

    def test_delete():
        cdel = ClientDelete()
        resp = cdel.delete(bucket, key, root)
        assert resp.status == 204

    runner(create_bucket)
    runner(test_mp_upload)
    runner(test_download)
    runner(test_status)
    runner(test_delete)
    loop.run_until_complete(client.close())
