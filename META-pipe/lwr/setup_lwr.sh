#!/bin/bash
cp conf/* lwr/
source env/bin/activate

cd lwr
#echo kombu >> requirements.txt
pip install -r requirements.txt
cp server.ini.sample server.ini

