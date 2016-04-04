#!/bin/bash
virtualenv -p python2.7 env
source env/bin/activate
ln -s /usr/lib64/python2.6/site-packages/pycurl.so $VIRTUAL_ENV/lib/python*/site-packages
ln -s /usr/lib64/python2.6/site-packages/curl $VIRTUAL_ENV/lib/python*/site-packages
