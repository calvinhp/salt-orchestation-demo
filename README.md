# Getting start with Salt Orchestration

This demo will create a cluster of CentOS 7 machines using Vagrant and Virtualbox. Currently there is an issue with Vagrant 1.9.1 and the `centos/7` box that won't allow `private_networks` on another interface to start up correctly. Downgrading to Vagrant 1.9 will make this work.  See https://seven.centos.org/2016/12/updated-centos-vagrant-images-available-v1611-01/ for information about this.

There is a bug in Salt and Vagrant 1.8.7 which causes the provisioning to be noisy/fail. Make sure you are on Vagrant 1.9 for this to work correctly.
