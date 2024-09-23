#!/usr/bin/env python3

import sys
import ollama


while True:
    sys.stdout.write(">>> ")
    prompt = input()

    response = ollama.chat(model='phi3', messages=[
      {
        'role': 'user',
        'content': prompt,
      },
    ])
    print("%s\n" % response['message']['content'])

