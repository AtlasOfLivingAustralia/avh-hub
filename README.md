### avh-hub   [![Build Status](https://travis-ci.org/AtlasOfLivingAustralia/avh-hub.svg?branch=master)](https://travis-ci.org/AtlasOfLivingAustralia/avh-hub)

Australian Virtual Herbarium Hub (avh-hub)
==========================================

Grails application that provides UI and customisations to the [ALA Biocache](https://github.com/AtlasOfLivingAustralia/biocache-hubs)
(Grails plugin) for [http://avh.ala.org.au/](http://avh.ala.org.au/).

Deploying AVH
=============

If you have not yet installed Ansible, Vagrant, or VirtualBox, use the instructions at the (ALA Install README.md file)[https://github.com/AtlasOfLivingAustralia/ala-install/blob/master/README.md] to install those first for your operating system.

Then, to deploy AVH onto a local virtual box install use the following instructions:

```
$ cd gitrepos
$ git clone git@github.com:AtlasOfLivingAustralia/ala-install.git
$ (cd ala-install/vagrant/ubuntu-trusty && vagrant up)
```

Add a line to your /etc/hosts file with the following information, replacing '10.1.1.3' with whatever IP address is assigned to the virtual machine that Vagrant starts up in VirtualBox:

```
10.1.1.3 avh.ala.org.au
```

Then you can clone the ansible instructions and install it onto the given machine:

```
$ git clone git@github.com:AtlasOfLivingAustralia/ansible-inventories.git
$ ansible-playbook -i ansible-inventories/avh.ala.org.au ala-install/ansible/avh-hub-standalone.yml --private-key ~/.vagrant.d/insecure_private_key -vvvv --user vagrant --sudo
```
