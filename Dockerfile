FROM amazonlinux:2

# Update yum
RUN yum update -y
RUN yum install wget unzip default-jdk libfindbin-libs-perl -y

# Add node's source repo
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -

# Install nodejs
RUN yum -y install nodejs

# Create a dedicated directory for the application
RUN mkdir -p /var/app

# Get the app from S3
# RUN aws s3 cp s3://awstecess02/app.zip 
RUN wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/ILT-TF-100-TECESS-5/app/app.zip

# Unzip it into a specific folder
RUN unzip app.zip -d /var/app/
WORKDIR /var/app

# Update environment variables for app
RUN sed -i "s+process.env.PHOTOS_BUCKET || ''+process.env.PHOTOS_BUCKET || 'awstecess01'+g" /var/app/api/common/constants.js
RUN sed -i "s+process.env.DEFAULT_AWS_REGION || ''+process.env.DEFAULT_AWS_REGION || 'us-east-1'+g" /var/app/api/common/constants.js
RUN sed -i "s+process.env.SHOW_ADMIN_TOOLS || 0+process.env.SHOW_ADMIN_TOOLS || 1+g" /var/app/api/common/constants.js

# Install dependencies
RUN npm install

EXPOSE 80

RUN node server.js

