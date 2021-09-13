#!/bin/bash

trap "exit \$exit_code" INT TERM
trap "exit_code=\$?; kill 0" EXIT

HOST=127.0.0.1
PORT=3333

NUM=`netstat -tlpn 2>/dev/null | grep -c " ${HOST}:${PORT} "`
if [ $NUM -gt 0 ]; then
      exit
fi

listenCopy(){
 echo "Start listen on ${PORT}"
 # Check if daemon run under WSL to use clip.exe instead xlip
  if [[ $(uname -srm) =~ "microsoft" ]]; then
    while [ true ]; do
      echo '1'
      nc -l ${HOST} ${PORT} | clip.exe
    done
  else
    while [ true ]; do
      nc -l ${HOST} ${PORT} | xclip -selection clipboard
    done
  fi
}

listenCopy& ssh -R "${PORT}:localhost:${PORT}" "$@"
