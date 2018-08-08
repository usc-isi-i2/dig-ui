#!/usr/bin/env bash

# Move to script folder.
cd "${0%/*}"

echo "Looking for DIG indices..."

es_base=${1%/}

response=$(curl $es_base --write-out %{http_code} --silent --output /dev/null)
until [[ $response = "200" ]]
do
  response=$(curl $es_base --write-out %{http_code} --silent --output /dev/null)
  sleep 2
done


logs=$es_base/dig-logs
response=$(curl $logs --write-out %{http_code} --silent --output /dev/null)
if [ $response = "200" ]; then
  echo "$logs does exist"
else
  echo "$logs does NOT exist"
  source create_logs_index.sh $es_base
fi

profiles=$es_base/dig-profiles
response=$(curl $profiles --write-out %{http_code} --silent --output /dev/null)
if [ $response = "200" ]; then
  echo "$profiles does exist"
else
  echo "$profiles does NOT exist"
  source create_profiles_index.sh $es_base
fi

states=$es_base/dig-states
response=$(curl $states --write-out %{http_code} --silent --output /dev/null)
if [ $response = "200" ]; then
  echo "$states does exist"
else
  echo "$states does NOT exist"
  source create_states_index.sh $es_base
fi
