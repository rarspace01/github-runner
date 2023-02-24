#!/bin/bash
set -e
TOKEN=$TOKEN
echo "Will build for Stage: $STAGE"
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 994318991266.dkr.ecr.eu-west-1.amazonaws.com
docker build . -t github-runner:"${TOKEN,,}"
docker tag github-runner:"${TOKEN,,}" 994318991266.dkr.ecr.eu-west-1.amazonaws.com/github-runner:"${TOKEN,,}"
docker push 994318991266.dkr.ecr.eu-west-1.amazonaws.com/github-runner:"${TOKEN,,}"
echo "pushed image"
aws eks update-kubeconfig --region eu-west-1 --name sandbox --role-arn arn:aws:iam::994318991266:role/AccountAutomation
echo "got credentials"
cat deployment.yaml | sed "s,{{TOKEN}},${TOKEN},g" | sed "s,{{TAG}},${TOKEN,,},g" | kubectl apply -f -
echo "deployed image"