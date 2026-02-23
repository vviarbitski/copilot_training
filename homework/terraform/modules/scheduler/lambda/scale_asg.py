import json
import os

import boto3


autoscaling = boto3.client("autoscaling")


def handler(event, context):
    # EventBridge target input supplies the desired capacity.
    target_capacity = int(event.get("target_capacity", 0))
    asg_name = os.environ["ASG_NAME"]

    autoscaling.set_desired_capacity(
        AutoScalingGroupName=asg_name,
        DesiredCapacity=target_capacity,
        HonorCooldown=False,
    )

    return {
        "status": "ok",
        "asg_name": asg_name,
        "target_capacity": target_capacity,
        "event": json.dumps(event),
    }
