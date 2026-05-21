#!/bin/bash
set -e

yum update -y
yum install -y docker amazon-cloudwatch-agent
systemctl start docker
systemctl enable docker

# Write env file
cat > /root/.env << ENVEOF
MONGO_URI=${mongo_uri}
DB_NAME=much_todo_db
REDIS_ADDR=${redis_host}:${redis_port}
ENABLE_CACHE=false
JWT_SECRET_KEY=${jwt_secret_key}
JWT_EXPIRATION_HOURS=72
PORT=8080
SECURE_COOKIE=false
ALLOWED_ORIGINS=${allowed_origins}
ENVEOF

# Login to ECR and pull image
aws ecr get-login-password --region ${aws_region} | \
  docker login --username AWS --password-stdin ${ecr_repository_url}

docker pull ${ecr_repository_url}:latest || true

# Run backend container
docker run -d \
  --name backend \
  --restart always \
  -p 8080:8080 \
  -v /root/.env:/root/.env \
  ${ecr_repository_url}:latest || true

# Configure CloudWatch agent
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'CWEOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/lib/docker/containers/**/*-json.log",
            "log_group_name": "/starttech/backend",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%Y-%m-%dT%H:%M:%S"
          }
        ]
      }
    }
  },
  "metrics": {
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_user"],
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      }
    }
  }
}
CWEOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s