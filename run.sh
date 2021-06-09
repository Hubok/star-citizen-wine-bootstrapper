#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source $SCRIPT_DIR/env_vars

gamemoderun $WINE "$WINEPREFIX/drive_c/Program Files/Roberts Space Industries/RSI Launcher/RSI Launcher.exe" --use-gl=osmesa
