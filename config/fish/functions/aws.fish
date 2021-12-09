function aws_instances -d "Show instances"
  aws ec2 describe-instances \
    --query 'Reservations[].Instances[].{ID:InstanceId,PublicIP:PublicIpAddress,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name}' \
    --output table
end

function aws_stack_outputs -d "Show stack outputs"
  aws cloudformation describe-stacks \
      --stack-name "$1" \
      --query "Stacks[0].Outputs" \
      --output json | jq 'reduce .[] as $i ({}; .[$i.OutputKey] = $i.OutputValue)'
end
