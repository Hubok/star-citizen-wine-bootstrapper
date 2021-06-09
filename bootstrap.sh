#!/bin/bash

source env_vars

## Show commands being run
set +x

## Create directories and see if valid wine and dxvk releases are available.

if ! [[ -d $SC_LOCATION ]]; then
	while true; do
		read -p "Create $SC_LOCATION? [y/n]: " yn
		case $yn in
			[Yy]* ) mkdir $SC_LOCATION; break;;
			[Nn]* ) exit 101;;
			* ) echo "Create $SC_LOCATION? [y/n]: ";;
		esac
	done
fi

if ! [[ -d $SC_LOCATION/wine ]]; then                                                                                                            
    while true; do                                                                                                                          
        read -p "Create $SC_LOCATION/wine? [y/n]: " yn                                                                                           
        case $yn in                                                                                                                         
            [Yy]* ) mkdir $SC_LOCATION/wine; break;;                                                                                             
            [Nn]* ) exit 102;;                                                                                                              
            * ) echo "Create $SC_LOCATION/wine? [y/n]: ";;                                                                                       
        esac                                                                                                                                
    done                                                                                                                                    
fi

if ! [[ -d $SC_LOCATION/dxvk ]]; then                                                                                                            
    while true; do                                                                                                                          
        read -p "Create $SC_LOCATION/dxvk? [y/n]: " yn                                                                                           
        case $yn in                                                                                                                         
            [Yy]* ) mkdir $SC_LOCATION/dxvk; break;;                                                                                             
            [Nn]* ) exit 103;;                                                                                                              
            * ) echo "Create $SC_LOCATION/dxvk? [y/n]: ";;                                                                                       
        esac                                                                                                                                
    done                                                                                                                                    
fi

if ! { [ -f $WINE ] && [ -f $DXVK_LOCATION/setup_dxvk.sh ]; }; then
	echo "Please check WINE_VERSION and DXVK_VERSION in the env file, and be sure those versions are in the wine and dxvk folders."
	exit 201
fi

## Check to see if boostrapper has already run.
if [ -f $SC_LOCATION/.bootstrap_lock ]; then
	echo "ERR: Bootstraper has already run in directory."
	exit 301
fi

## Create lockfile and required directories.
touch $SC_LOCATION/.bootstrap_lock
mkdir -p $SC_LOCATION/pfx $SC_LOCATION/wine

## Run winecfg and set Windows 10.
echo "Please set Windows version to Windows 10 and press OK."
$WINEVERPATH/bin/winecfg

## Install dependencies with winetricks. dvxk is skipped as we're supplying our own.
winetricks arial win10

## Install dxvk or dxvk-async
chmod +x $DXVK_LOCATION/setup_dxvk.sh
bash $DXVK_LOCATION/setup_dxvk.sh install

## Install launcher
wget -O $SC_LOCATION/installer.exe https://install.robertsspaceindustries.com/star-citizen/RSI-Setup-$RSI_SETUP_VERSION.exe
$WINE $SC_LOCATION/installer.exe
rm $SC_LOCATION/installer.exe

## Create .desktop file for launcher
echo -e "[Desktop Entry]\nName=Star Citizen\nExec=$SC_LOCATION/run.sh\nType=Application\nCategories=Games" > $HOME/.local/share/applications/starcitizen.desktop
