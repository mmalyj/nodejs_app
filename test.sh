#!/bin/bash
# The first parameter passed to this script will be used as an image version.
# If none is passed, latest will be used as a tag.
if [ -z "${1}" ]; then
        version="latest"
else
        version="${1}"
fi
cd nodejs_app
docker run -d --name node_app_test -p 8000:8000 mmalyj/nodejs_app:${version}
echo "Testing image: mmalyj/nodejs_app:${version}"
# Allow the webserver to start up
sleep 5
# Test will be successful if the webpage at the
# following URL includes the word .success.
curl -s GET http://127.0.0.1:8000 | grep Hello
status=$?
# Clean up the testing container
docker kill node_app_test
docker rm node_app_test
if [ $status -eq 0 ] ; then
        echo "Test succeeded"
else
        echo "Test failed"
fi
cd ..
exit $status

