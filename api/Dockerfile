FROM python:3.7

ENV FLASK_APP main

ADD src/ /app

WORKDIR /app

RUN mkdir -p data/ && \
    pip install -r requirements.txt

CMD ["python", "main.py"]
