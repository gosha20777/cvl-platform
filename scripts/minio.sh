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