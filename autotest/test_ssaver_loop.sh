#!/bin/bash
#
# test_ssaver_loop.sh
#
# Simple rustic script to automate Kano OS screen saver testing.
# It will go into the following cycle in an endless loop.
#
# Dashboard -> Overworld -> SSaver -> Dashboard -> Ssaver -> Classic Mode -> SSaver, back to start.
#
# Requirements:
#
#  1) edit /usr/share/kano-desktop/kdesk/kdeskrc_screensaver, set ScreenSaverTimeout: 15
#  2) edit /usr/share/kano-desktop/kdesk/.kdeskrc, set ScreenSaverTimeout: 15
#  3) Make sure you are on the Dashboard on idle status, then run:
#
#  $./test_ssaver_loop.sh > $HOME/ssaver-loop.log 2>&1
#
#  Recommend to use a screen multiplexer.
#  A GPU memory sample is saved on each transition. Grep for "reloc" on the logfile.
#

# Time in seconds for the screen saver to run
ssaver_wait=420

while true
do
    echo "$(date) Looping starts now"

    echo "$(date) Going to Overworld"
    touch /tmp/dashtest-kanoOverworld
    pkill qmlmatrix
    kill $(pidof kano-dashboard)
    echo "$(date) Waiting for screen saver..."
    sleep $ssaver_wait
    ps aux|grep qmlmatrix
    vcgencmd get_mem reloc

    echo "$(date) Returning to the Dashboard"
    pkill qmlmatrix
    kill $(pidof -x love)
    echo "$(date) Waiting for screen saver"
    sleep $ssaver_wait
    ps aux|grep qmlmatrix
    vcgencmd get_mem reloc

    echo "$(date) Going to Desktop mode"
    kano-dashboard-uimode desktop
    echo "$(date) Wait for screen saver..."
    sleep $ssaver_wait
    ps aux|grep qmlmatrix
    vcgencmd get_mem reloc

    echo "$(date) Going to Dashboard mode"
    kano-dashboard-uimode dashboard
    echo "$(date) Wait for screen saver..."
    sleep $ssaver_wait
    ps aux|grep qmlmatrix
    vcgencmd get_mem reloc

done

