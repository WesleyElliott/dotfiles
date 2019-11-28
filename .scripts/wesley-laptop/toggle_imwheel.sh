if pgrep imwheel > /dev/null
then
    echo "[timwheel] Running, disabing"
    imwheel -q -k
else
    "[timwheel] Not running, starting"
    imwheel -b "4 5"
fi
