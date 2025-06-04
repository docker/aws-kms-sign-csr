# aws-kms-sign-csr

Given an existing CSR (in PEM format) and a keypair in AWS KMS, this script:

- updates the public key to the public key of the asymmetric keypair
- signs the CSR with the private key of the asymmetric keypair

## Why would I want to do this?

You may have a use-case where you're signing arbitrary data using KMS, but checking
this signature against a certificate (or, by extension, checking that the certificate
has been chained from a trusted root or intermediate).

This script allows you to generate a CSR which uses the private key in KMS, which
can then be signed by your PKI. From here you can sign your arbitrary data using
KMS and you've maintained the security of your private key, as it has never left
KMS.

Note that this does NOT sign the CSR with a CA to make it into a bona fide certificate:
a CSR is signed with the private key of the generator so that the CA can ensure
that the public key is owned by the person who is requesting the certificate, and
this script re-signs with the private key held in KMS.

## Usage

```
docker build --tag aws-kms-sign-csr:latest .
AWS_PROFILE=your_profile
KMS_KEY_ID=key_uuid
CSR=absolute_csr_path
docker run \
    -e AWS_PROFILE \
    -v ~/.aws:/root/.aws \
    -v $CSR:/app/unsigned.csr \
    aws-kms-sign-csr:latest \
    --region us-east-1 \
    --keyid $KMS_KEY_ID \
    --hashalgo sha256 /app/unsigned.csr > signed.csr
```

## Limitations

- only supports RSA with sha256, sha384 and sha512 and ECDSA with sha224, sha256, sha384, sha512 at time of writing
- should have better error handling
- should have better handling of boto profiles
