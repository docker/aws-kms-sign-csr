FROM python:alpine

WORKDIR /app

ADD requirements.txt .
RUN pip3 install -r requirements.txt

ADD aws-kms-sign-csr.py .
ENTRYPOINT ["python3", "aws-kms-sign-csr.py"]