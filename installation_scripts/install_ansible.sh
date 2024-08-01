#!/bin/bash

# Add Ansible PPA
sudo apt-add-repository ppa:ansible/ansible -y

# Refresh package lists and install Ansible
sudo apt-get update -y
sudo apt-get install ansible -y

# Installing the ansible.builtin.docker_container module
ansible-galaxy collection install community.docker
