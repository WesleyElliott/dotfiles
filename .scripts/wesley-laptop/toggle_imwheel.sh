if pgrep imwheel > /dev/null
then
    echo "Running, disabing"
    imwheel -q -k
else
    "Not running, starting"
    imwheel -b "4 5"
fi
