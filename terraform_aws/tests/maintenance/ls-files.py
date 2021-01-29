#!/usr/bin/python3

# Maintenance Script: LS
#
# This Script is a peace of mind script for testing purposes.
# It will go to the 2 buckets defined in 'vars' and list
# the bucket contents to screen


import boto3

##@ bump buckets to dict, use in combined function @##

# Vars for S3 Buckets
log_bucket = "jaysons-logbucket"


def log_ls_legacy():
    '''
    Connect to the legacy bucket & print results

    TODO - Merge this and the modern function, as a single function

    TODO - Add error handling
    '''
    session = boto3.Session()
    s3 = session.resource('s3')
    bucket = s3.Bucket(log_bucket)

    for obj in bucket.objects.all():
        names = [bucket.name,obj.key]
        print(names)


log_ls_legacy()



