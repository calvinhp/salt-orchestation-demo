# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install Avahi so we have mDNS lookups for our salt network
$script = <<SCRIPT
yum install -y avahi avahi-tools avahi-dnsconfd
yum install -y epel-release
yum --enablerepo="epel" install -y nss-mdns
systemctl enable avahi-dnsconfd
systemctl start avahi-dnsconfd
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.define "salt", primary: true do |salt|
    salt.vm.hostname = "salt"
    salt.vm.network "private_network", ip: "10.10.10.10",
      virtualbox__intnet: true
    salt.vm.provision "shell", inline: $script
    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--cpus", 1]
        v.linked_clone = true
    end
  end

  config.vm.define "proxy", primary: true do |proxy|
    proxy.vm.hostname = "proxy"
    proxy.vm.network "private_network", ip: "10.10.10.100",
      virtualbox__intnet: true
    proxy.vm.provision "shell", inline: $script
    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", 256]
        v.customize ["modifyvm", :id, "--cpus", 1]
        v.linked_clone = true
    end
  end

  (1..3).each do |i|
    config.vm.define "app#{i}" do |node|
      node.vm.hostname = "app#{i}"
      node.vm.network "private_network", ip: "10.10.10.#{i+10}",
        virtualbox__intnet: true
      node.vm.provision "shell", inline: $script
      config.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--memory", 512]
          v.customize ["modifyvm", :id, "--cpus", 1]
          v.linked_clone = true
      end
    end
  end

  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "10.10.10.101",
      virtualbox__intnet: true
    db.vm.provision "shell", inline: $script
    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--cpus", 1]
        v.linked_clone = true
    end
  end

end
