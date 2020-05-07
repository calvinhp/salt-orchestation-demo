# Getting start with Salt Orchestration

This repository contains the salt states needed to configure a set of VMs to demo SaltStack.

## Local Salt Testing

When creating state for this project you can test them locally using [Vagrant](https://www.vagrantup.com). The current `Vagrantfile` is configure to bring up multiple virtual machines using [VirtualBox](https://www.virtualbox.org).

Current Servers in `Vagrantfile`

* salt
* proxy
* app1
* app2
* app3
* db

## Installing Vagrant

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
2. Install [Vagrant](https://www.vagrantup.com/downloads.html).

## Spinning up the virtual machines

Now that you have the required dependancies, you can start up a server to try your salt states onto.

The `vagrant` command will now be available from the command line. You will use this to start, stop and SSH into the virtual machines.

### Start All of the Servers

You will need a lot of RAM...

```console
$ vagrant up
```

### Start just the Salt Master

```console
$ vagrant up salt
```

Once it is bootstrapped the Salt master will still need to be highstated.

The `salt.run_highstate = true` Vagrant option will not work for the master as we would have to pre-seed the keys. That topic is out of scope for this demo and easy to work around.

```console
$ vagrant ssh salt
$ sudo salt salt state.apply
```

### Start just one of the Application Servers

```console
$ vagrant up app1
```

### Start just the Master and one App server

```console
$ vagrant up salt app1
```

### Shell into the Servers

```console
$ vagrant ssh salt
```

## Modify and Try the Salt States

```console
$ vagrant up app1
Bringing machine 'app1' up with 'virtualbox' provider...
...
$ vagrant ssh app1
ubuntu@app1:~$ sudo salt-call state.apply
```

You can now edit the files locally on your workstation and re-run the `state.apply` as needed. You do not need to sync or reboot the VM for the changes to be picked up.

### Test just one State

```console
ubuntu@app1:~$ sudo salt-call state.apply django.code
```

### Test just one ID in a Single State

```console
ubuntu@app1:~$ sudo salt-call state.sls_id django django.django-deps
```

## Shutting down your Virtual Machines

This will stop the running VMs, but will leave the data on your system.

```console
$ vagrant halt
```

To completely remove the data from the system, you can `destroy` the setup.

```console
$ vagrant destroy
```

That command will destroy the VMs, but your changes to the salt states remain in this repository.
