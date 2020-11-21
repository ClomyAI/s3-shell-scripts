#!/bin/sh
helpFunc()
{
   echo ""
   echo "Usage: $0 -b bucket -k filename -p aws_profile -s part_size"
   echo "\t-b S3 Bucket Name for multipart uploads"
   echo "\t-k The name of the file you want for multipart upload"
   echo "\t-p Your AWS profile"
   echo "\t-s The part size in mb for multipart upload, eg. 100mb"
   exit 1 # Exit script
}

while getopts 'k:s:p:b:' opt
do
  case $opt in
    b ) BUCKET=$OPTARG ;;
    p ) PROFILE=$OPTARG ;; 
    k ) KEY=$OPTARG ;;
    s ) SIZE=$OPTARG ;; 
    ? ) helpFunc ;; # Print helpFunc if the parameter doesn't exist
   esac
done

if [ -z "$KEY" ] || [ -z "$SIZE" ] || [ -z "$BUCKET" ] || [ -z "$PROFILE" ] # if they are empty
then
   echo "Required parameters are empty";
   helpFunc
fi

# get UploadID from json, need jq - brew install jq
# AWS Cli - Initiate the multipart upload
UPLOAD_ID=$(aws s3api --profile $PROFILE create-multipart-upload --bucket $BUCKET --key $KEY | jq -r '.UploadId') 
# echo $UPLOAD_ID

DIR="PART_$(date +%s)"
mkdir $DIR
split -b $SIZE $KEY $DIR/ # create part files in temp directory
i=0
PART_JSON='{ "Parts": []}'

for file in $(ls $DIR) # list all part files
do
  i=$((i+1))
  # Use MD5 checksum to validate the integrity of the upload for each part
  MD5=$(openssl md5 -binary $DIR/$file | base64)
  
  # AWS Cli - Upload parts to S3, keep the ETag
  ETAG=$(aws --profile $PROFILE s3api upload-part --bucket $BUCKET --key $KEY --part-number $i --body $DIR/$file --upload-id $UPLOAD_ID --content-md5 $MD5 | jq -r '.ETag')
  
  echo "Part number $i is complete, ETag is $ETAG"
  # Preparing the JSON required for completing uploads
  PART_JSON=$(echo $PART_JSON | jq --arg i $i --arg ETAG $ETAG '.Parts += [{"PartNumber": $i|tonumber, "ETag": $ETAG }]') # use tonumber to parse string to integer
done

echo $PART_JSON > $DIR/part.json # create JSON file of uploaded parts

# AWS Cli - complete upload
aws s3api --profile $PROFILE complete-multipart-upload --multipart-upload file://$DIR/part.json --bucket $BUCKET --key $KEY --upload-id $UPLOAD_ID

rm -r $DIR



