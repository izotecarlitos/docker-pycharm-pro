#!/bin/bash

# Copy debug-eggs folder to $PYCHARM_DEBUGEGGS
cp -r /opt/pycharm/debug-eggs/. /home/developer/PycharmSettings/debugeggs

/opt/pycharm/bin/pycharm.sh
