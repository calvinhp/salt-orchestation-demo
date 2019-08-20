# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install Avahi so we have mDNS lookups for our salt network
$script = <<SCRIPT
apt-get -y update
apt-get -y install avahi-daemon avahi-utils avahi-dnsconfd
apt-get -y install libnss-mdns
systemctl enable avahi-dnsconfd
systemctl start avahi-dnsconfd
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell", inline: $script

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end

  config.vm.define "salt", primary: true do |master|
    master.vm.hostname = "salt"
    master.vm.network "private_network", ip: "10.10.10.10"
    master.vm.synced_folder "salt/roots/states", "/srv/salt/", type: "nfs"
    master.vm.synced_folder "salt/roots/formulas", "/srv/formulas/", type: "nfs"
    master.vm.synced_folder "salt/roots/pillar", "/srv/pillar/", type: "nfs"
    master.vm.synced_folder "salt/roots/reactor", "/srv/reactor/", type: "nfs"
    master.vm.provision :salt do |salt|
      salt.install_master = true
      salt.grains_config = "salt/grains-master.yml"
    end
    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--cpus", 1]
        v.linked_clone = true
    end
  end

  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "10.10.10.101"
    db.vm.provision :salt do |salt|
      salt.run_highstate = true
      salt.grains_config = "salt/grains-db.yml"
    end
    db.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--cpus", 1]
        v.linked_clone = true
    end
  end

  (1..2).each do |i|
    config.vm.define "app#{i}" do |node|
      node.vm.hostname = "app#{i}"
      node.vm.network "private_network", ip: "10.10.10.#{i+10}"
      node.vm.provision :salt do |salt|
        salt.run_highstate = true
        salt.grains_config = "salt/grains-app.yml"
      end
      node.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--memory", 768]
          v.customize ["modifyvm", :id, "--cpus", 1]
          v.linked_clone = true
      end
    end
  end

  config.vm.define "proxy", primary: true do |proxy|
    proxy.vm.hostname = "proxy"
    proxy.vm.network "private_network", ip: "10.10.10.100"
    proxy.vm.provision :salt do |salt|
      salt.run_highstate = true
      salt.grains_config = "salt/grains-proxy.yml"
    end
    proxy.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", 512]
        v.customize ["modifyvm", :id, "--cpus", 1]
        v.linked_clone = true
    end
  end

end
