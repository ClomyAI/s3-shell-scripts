#!/bin/sh
helpFunc()
{
   echo ""
   echo "Usage: $0 -b bucket -p aws_profile"
   echo "\t-b S3 Bucket Name for multipart uploads"
   echo "\t-p Your AWS profile"
   exit 1 # Exit script
}

while getopts 'b:p:' opt
do
  case $opt in
    b ) BUCKET=$OPTARG ;;
    p ) PROFILE=$OPTARG ;;
    ? ) helpFunc ;; # Print helpFunc if the parameter doesn't exist
   esac
done

if [ -z "$BUCKET" ] || [ -z "$PROFILE" ] # if they are empty
then
   echo "Required parameters are empty";
   helpFunc
fi

UPLOADS=$(aws --profile $PROFILE s3api list-multipart-uploads --bucket $BUCKET | jq '.Uploads') # AWS Cli list all multipart uploads for the bucket

for u in $(echo $UPLOADS | jq -c '.[]') # jq -c get rid of extra lines
do
   uid=$(echo $u | jq -r '.UploadId') # jq -r get rid of extra quotes
   key=$(echo $u | jq -r '.Key')
   # echo $uid $key
   aws s3api --profile $PROFILE abort-multipart-upload --bucket $BUCKET --key $key --upload-id $uid # AWS Cli abort multipart upload for the key in the bucket
done