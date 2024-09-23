ARG ARCH=
FROM ${ARCH}ubuntu:24.04

RUN apt-get update && apt-get install -y curl netcat-traditional && apt-get autoremove -y

RUN curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION=0.3.11 sh

COPY pull-llm.sh .

RUN chmod +x ./pull-llm.sh && ./pull-llm.sh

RUN mkdir -p /root/app
WORKDIR /root/app
RUN apt-get update && apt-get install -y python3-full python3-pip && apt-get autoremove -y
RUN python3 -m venv venv
RUN ./venv/bin/pip install ollama chromadb

# Force download of default embedding model
RUN ./venv/bin/python -c 'import chromadb; chroma_client = chromadb.Client(); collection = chroma_client.create_collection(name="my_collection"); collection.add(documents=["Test"], ids=["Test"])'

COPY cmd.sh .
RUN chmod +x cmd.sh
CMD ["/root/app/cmd.sh"]

COPY app.py .
