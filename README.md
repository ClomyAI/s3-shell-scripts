# S3 Shell Scripts
 
S3 Shell Scripts projects created by Cloudemy (http://cloudemy.tv).


#### Learn more about AWS and Cloud on Youtube: [Cloudemy TV](http://youtube.cloudemy.tv) http://youtube.cloudemy.tv

## Prerequisite 

You need to install command line json parser: jq

https://stedolan.github.io/jq/download/

Install jq

For Mac OS: brew install jq

For Linux ubuntu: sudo apt-get install jq

For Windows: chocolatey install jq

## Commands:

### Multipart Uploads

This is a combined step to upload large object to S3 using multipart upload.

This script will:
1. initiate the multipart uploads
2. split the file for upload
3. upload parts
4. complete the multipart upload

Command:

    sh s3_mpupload.sh -p your_AWS_profile -b your_s3_bucket -k your_file_to_upload -s part_size_in_mb

Example:

    sh s3_mpupload.sh -p john -b cloudemy-bucket -k large_file.zip -s 100mb

### Abort All Uploads

Warning: 

Unexpected incomplete multipart uploads can incur extra storage costs. 

This command will remove all incomplete multipart uploads.

As a best practice, AWS recommends you configure a lifecycle rule (using the AbortIncompleteMultipartUpload action) to minimize your storage costs.

Command:

    sh s3_abort_all_mpupload.sh -p your_AWS_profile -b your_s3_bucket

Example:

    sh s3_mpupload.sh -p john -b cloudemy-bucket