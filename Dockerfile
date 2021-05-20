# Start from the code-server Debian base image
FROM codercom/code-server:3.9.3 

USER root

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip ssh -y
RUN sudo service ssh start
# Port
ENV PORT=22

# Use our custom entrypoint script first
COPY setup.sh /usr/bin/setup.sh
ENTRYPOINT ["/usr/bin/setup.sh"]
