#!/bin/sh

set -e

nohup ollama serve &
OLLAMA_PID=$!

while ! nc -z localhost 11434; do
  sleep 0.1  # wait for 1/10 of the second before check again
done


./venv/bin/python app.py


kill -INT $OLLAMA_PID
wait
