# set -x;
# export AWS_S3_ENDPOINT_URL=http://172.17.0.1 # Might not be necessary since this is required in the .env with minio
# export MINIO_SECRET_KEY=1234567890 # Not be necessary if the minio is created with a dedicated docker-compose file.
# export AWS_STORAGE_BUCKET_NAME=public # Same as both points above
# export AWS_STORAGE_PRIVATE_BUCKET_NAME=private # Same as both points above
# /usr/bin/mc config host add minio_docker $AWS_S3_ENDPOINT_URL $MINIO_ACCESS_KEY $MINIO_SECRET_KEY; # Only necessary with SSL
# /usr/bin/mc mb minio_docker/$AWS_STORAGE_BUCKET_NAME; 
# /usr/bin/mc mb minio_docker/$AWS_STORAGE_PRIVATE_BUCKET_NAME;
# /usr/bin/mc anonymous set download minio_docker/$AWS_STORAGE_BUCKET_NAME;
# exit 0;


set -x;
if [ -n \"$AWS_ACCESS_KEY_ID\" ] && [ -n \"$AWS_SECRET_ACCESS_KEY\" ]
then
    until /usr/bin/mc config host add minio_docker http://minio:9000 $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY && break; do 
        echo '...waiting...' && sleep 5; 
    done;
    /usr/bin/mc mb minio_docker/$AWS_STORAGE_BUCKET_NAME || echo 'Bucket $AWS_STORAGE_BUCKET_NAME already exists.';
    /usr/bin/mc mb minio_docker/$AWS_STORAGE_PRIVATE_BUCKET_NAME || echo 'Bucket $AWS_STORAGE_PRIVATE_BUCKET_NAME already exists.';
    /usr/bin/mc anonymous set download minio_docker/$AWS_STORAGE_BUCKET_NAME;
else
    echo 'AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or MINIO_PORT are not defined. Skipping buckets creation.';
fi;
exit 0;