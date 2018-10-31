#!/usr/bin/env bash

set -ex

BUCKET_NAME=$1
REGION=${2:-ap-northeast-1}

# バケットの作成
aws s3api create-bucket --bucket ${BUCKET_NAME} --create-bucket-configuration LocationConstraint=${REGION}

# バケットのバージョニング設定
aws s3api put-bucket-versioning --bucket ${BUCKET_NAME} --versioning-configuration Status=Enabled

# バケットのデフォルト暗号化設定
aws s3api put-bucket-encryption --bucket ${BUCKET_NAME} --server-side-encryption-configuration '{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'

aws s3api get-bucket-location --bucket ${BUCKET_NAME}
aws s3api get-bucket-versioning --bucket ${BUCKET_NAME}
aws s3api get-bucket-encryption --bucket ${BUCKET_NAME}
