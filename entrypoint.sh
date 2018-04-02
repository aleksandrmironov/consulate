#!/usr/bin/env bash

instaceID=$(curl  http://169.254.169.254/latest/meta-data/instance-id)

echo "echo current instance ID $instaceID"

privateIP=$(aws ec2 describe-instances --filters --filter Name=instance-id,Values=$instaceID | jq '.Reservations[].Instances[].PrivateIpAddress' | tr -d '"')

echo "current private IP $privateIP"

consulate server --consul-address $privateIP:8500 $*