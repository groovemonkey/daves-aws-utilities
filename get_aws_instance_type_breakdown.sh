#!/bin/bash

set -euo pipefail

## get_aws_instance_type_breakdown
# v2: Dave's decomposed one-liner

# Using a tempfile to decompose this beastly one-liner
running_instances_file=$(mktemp)
aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" | jq '.Reservations[].Instances[].InstanceType' >> $running_instances_file

total_instances=$(wc -l < $running_instances_file)
echo ""
echo "You have a total of ${total_instances} running instances."
echo ""

# List instance types, ranked by occurrence
echo ""
cat $running_instances_file | sort | uniq -c | sort -rn
echo ""

# Clean up
rm $running_instances_file

exit 0