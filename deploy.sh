#!/bin/bash
marathon="10.141.141.10"
if [ -z "${1}" ]; then
	version="latest"
else
	version="${1}"
fi
# destroy old application
curl -X DELETE -H "Content-Type: application/json" \
	http://${marathon}:8080/v2/apps/app
# At this point we can query Marathon until the application is down.
sleep 1
# these lines will create a copy of app_marathon.json and update the image
# version. This is required for sing the cottect image tag, as the marathon
# configuration file does not support variables.
cp -f app_marathon.json app_marathon.json.tmp
sed -i "s/latest/${version}/g" app_marathon.json.tmp
# post the application to Marathon
curl -X POST -H "Content-Type: application/json" \
	http://${marathon}:8080/v2/apps \
	-d@app_marathon.json.tmp
