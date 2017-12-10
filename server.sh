#!/usr/bin/env bash

DEFAULT_GAME="csgo"
FOLDER_REPO="/srv/repo"

function funcStartServer {
	tmpCommandline=`cat $FOLDER_REPO/$DEFAULT_GAME/commandline.setting`

	tmpCommandline="${tmpCommandline/'[:ID:]'/`echo $1 | cut -d. -f 4`}"
	tmpCommandline="${tmpCommandline/'[:IP:]'/$1}"

	cd $FOLDER_REPO/$DEFAULT_GAME

	echo $tmpCommandline

	#eval $tmpCommandline
}

function funcStopServer {
  screen -r $(screen -ls | grep [.]GS$1|awk '{print $1}') -X quit
}

function funcStatus {
    screen -ls | grep [.]GS$1[[:space:]] > /dev/null
}

function funcOpenConsole {
  if ! funcStatus $1 ; then echo "Unable to locate server screen."; exit 1; fi

  screen -r $(screen -ls | grep [.]GS$1|awk '{print $1}')
}

function funcUsage {
  echo "Usage: $0 {start|stop|status|restart|console} {ip}"
  echo "On console, press CTRL+A then D to stop the screen without stopping the server."
}


case "$1" in
  start)
    if funcStatus $2
    then
      echo "The requested server is already running."
    else
      funcStartServer $2
    fi
  ;;
    
  stop)
    if funcStatus $2
    then
      funcStopServer $2
    else
      echo "Unable to find the requested server."
    fi
  ;;
    
  console)
    if funcStatus $2
    then
      funcOpenConsole $2
    else
      echo "Unable to find the requested server."
    fi
  ;;
      
  *)
    funcUsage
  ;;
esac
