#!/bin/sh

set -e

nohup ollama serve &
PID=$!
echo PID=$PID

while ! nc -z localhost 11434; do
  sleep 0.1  # wait for 1/10 of the second before check again
done



ollama pull phi3


kill -INT $PID
wait
