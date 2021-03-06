FROM codercom/code-server:3.9.3 

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip ssh -y
RUN curl https://rclone.org/install.sh | sudo bash
RUN sudo service ssh start
# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=22

RUN mkdir ~/.ssh;echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6uZrkoOIuv9uFviwCvY3PlHnf394OS/E0IR211A64kh+3tF/CupFqdMFjcIHu8sxm+/crRi1KBYUWDgxRwfrZHNuWaGlF3Ivdtjw38kx5zCX8+P9szP8LZxmHwNSq8MKZskq9gQgGDkfnHQUTj2oU/0Sp4yu+NtWKpIO2dP0yfQ7e3s1eNzvLXs8G3MJ9bI5X+cpchhHXc5s4gomV4c/g2lU4FK+HqKWpOmlAqXMJZMMbyojqUj30FYQSoJEiRDTjtzJitAAT96d6VKoiq4Z4s6UFErPrNolfyKIslFBOdQSNsvHnqZnpITzaNAPse3IX/DURRrDwXcQJwKzogL/T Test" > ~/.ssh/authorized_keys
# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
