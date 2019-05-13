#!/bin/bash

REPO=$1
if [ -z "$2" ]; then
    USER=$REPO
else
    USER=$2
fi
BASE=/www/$REPO/eprints3/bin

# editorial alerts
sudo -u $USER $BASE/send_alerts $REPO daily --quiet
if [[ $(date +%u) -eq 7 ]] # sunday
then
    sudo -u $USER $BASE/send_alerts $REPO weekly --quiet
fi
if [[ $(date +%-d) -eq 1 ]] # first of month
then
     sudo -u $USER $BASE/send_alerts $REPO monthly --quiet
fi

# housekeeping
sudo -u $USER $BASE/lift_embargos $REPO --quiet
sudo -u $USER $BASE/issues_audit $REPO --quiet

# larger repositories should generate view
# pages at different times/on different days
sudo -u $USER $BASE/generate_views $REPO --quiet

# irstats2
sudo -u $USER $BASE/../archives/$REPO/bin/stats/process_stats $REPO

# user / system time
times
