ARG BASE_IMAGE

FROM ${BASE_IMAGE}

COPY ./sample/requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY ./sample /app

ENTRYPOINT [ "python" ]

CMD [ "view.py" ]