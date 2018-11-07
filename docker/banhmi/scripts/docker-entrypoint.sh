#!/bin/bash

check_vars() {
    if [ -z "$ENV" ];
    then
        echo "ENV variable is required" >&2
        exit -1
    fi
}


config_banhmi() {
    if [ "$ENV" == "dev" ]; then
        ln -s /banhmi/etc/banhmi_dev.yml /etc/banhmi/banhmi.yml
    fi
    if [ "$ENV" == "prod" ]; then
        ln -s /banhmi/etc/banhmi_prod.yml /etc/banhmi/banhmi.yml
    fi
}

run_tests() {
    if [ -z "$RUN_TESTS" ];
    then
        export RUN_TESTS=No
    fi

    # The tests are ready only for the development environment with localstack
    if [ "$RUN_TESTS" == "Yes" ] && [ "$ENV" == "dev" ]; then
        sleep 15 # Wait 10 Seconds for localstack bootstrap
        /usr/bin/python /banhmi/tests/aiohttp-tests.py
    fi
}


check_vars
config_banhmi
run_tests
exec "$@"
