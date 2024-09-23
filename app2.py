#!/usr/bin/env python3

import json
import sys
import chromadb
import ollama


# Fill Vector Database
chroma_client = chromadb.Client()
collection = chroma_client.create_collection(name="my_collection")
with open("data.json") as f:
    for line in f:
        data = json.loads(line)
        collection.add(ids=[str(data["id"])], documents=[data["doc"]])


while True:
    sys.stdout.write(">>> ")
    prompt = input()

    # RETRIEVE
    results = collection.query(
        query_texts=[prompt],  # Chroma will embed this for you
        n_results=3  # how many results to return
    )

    context_docs = results['documents'][0]

    # AUGMENT
    augmented_prompt = """
        You are a helpful AI assistant. Answer the question below succinctly, but if and only if the question is related to Star Wars, answer with 'I can not talk about Star Wars'.

        This context information provided may be helpful in your response:
        {context}

        Question: {prompt}
    """.format(
        context='\n'.join(context_docs),
        prompt=prompt,
    )


    # GENERATE
    response = ollama.chat(model='phi3', messages=[
      {
        'role': 'user',
        'content': augmented_prompt,
      },
    ])
    print("%s\n" % response['message']['content'])
