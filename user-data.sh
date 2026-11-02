#!/bin/bash
dnf install -y docker
systemctl enable --now docker
cat > /opt/deploy.sh <<'EOS'
#!/bin/bash
export AWS_DEFAULT_REGION=ap-south-1
R=959891092671.dkr.ecr.ap-south-1.amazonaws.com
aws ecr get-login-password | docker login -u AWS --password-stdin $R
docker pull $R/hello-jenkins:latest
docker rm -f web || true
docker run -d --name web -p 80:80 $R/hello-jenkins:latest
EOS
chmod +x /opt/deploy.sh
/opt/deploy.sh
