#!/usr/bin/env sh
# based on and all credits to original:
# https://github.com/qoomon/aws-ssm-ec2-proxy-command/commit/c17b47b66eaf21835f80e26b452b14c525246d4f
# everything else is my doing but I haven't written original script
# so all thanks and cheers to @qoomon

set -eu

REGION_SEPARATOR='--'

ec2_instance_id="$1"
ssh_user="$2"
ssh_port="$3"
ssh_public_key_path="$4"

if echo "${ec2_instance_id}" | grep -qe "${REGION_SEPARATOR}"; then
  export AWS_DEFAULT_REGION="${ec2_instance_id##*${REGION_SEPARATOR}}"
  ec2_instance_id="${ec2_instance_id%%${REGION_SEPARATOR}*}"
fi

instance_availability_zone="$(aws ec2 describe-instances \
  --instance-id "${ec2_instance_id}" \
  --query "Reservations[0].Instances[0].Placement.AvailabilityZone" \
  --output text)"

aws ec2-instance-connect send-ssh-public-key \
  --instance-id "${ec2_instance_id}" \
  --instance-os-user "${ssh_user}" \
  --ssh-public-key "file://${ssh_public_key_path}" \
  --availability-zone "${instance_availability_zone}"
aws ssm start-session \
  --target "${ec2_instance_id}" \
  --document-name 'AWS-StartSSHSession' \
  --parameters "portNumber=${ssh_port}"
