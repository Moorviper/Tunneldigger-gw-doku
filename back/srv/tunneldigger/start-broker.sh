#!/bin/bash

WDIR=/srv/tunneldigger
VIRTUALENV_DIR=/srv/tunneldigger

cd $WDIR
source $VIRTUALENV_DIR/bin/activate

python broker/l2tp_broker.py l2tp_broker.cfg


