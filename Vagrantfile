VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  
  # Port-forwarding
  config.vm.network "forwarded_port", guest: 6379, host: 6379
  config.vm.network "forwarded_port", guest: 15672, host: 15672
  
  # Network
  config.vm.network "private_network", ip: "192.168.33.10"

  # Virtual Box-specific
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Provisioners
  config.vm.provision :shell, :path => "shell/bootstrap_puppet.sh"
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
  end
end
