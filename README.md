# S3 Shell Scripts
 
S3 Shell Scripts projects created by Cloudemy.

## Prerequisite 

You need to install command line json parser: jq

https://stedolan.github.io/jq/download/

Install jq

For Mac OS: brew install jq

For Linux ubuntu: sudo apt-get install jq

For Windows: chocolatey install jq

## Commands:

### Abort All Uploads

Warning: 

Unexpected incomplete multipart uploads can incur extra storage costs. 

This command will remove all incomplete multipart uploads.

As a best practice, AWS recommends you configure a lifecycle rule (using the AbortIncompleteMultipartUpload action) to minimize your storage costs.

    sh s3_abort_all_mpupload.sh -b your_s3_bucket -p your_AWS_profile

