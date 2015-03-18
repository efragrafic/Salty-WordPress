# -*- mode: ruby -*-
# vi: set ft=ruby :

# 'projects' and 'logs' directories are ignored in the repo, so let's make sure they exist
FileUtils.mkdir_p(File.dirname(__FILE__)+'/projects')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/projects/default')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/logs')

Vagrant.configure("2") do |config|

  vagrant_version = Vagrant::VERSION.sub(/^v/, '') 

	config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.box = "1404-64bit-virtualbox"
  config.vm.box_url = "http://hmn-uploads.s3.amazonaws.com/salty-wordpress/salty-wordpress-14-04-vbox-2014-07-12.box"
  config.vm.provider "vmware_fusion" do |v, override|
    override.vm.box = "1404-64bit-vmware"
    override.vm.box_url = "http://hmn-uploads.s3.amazonaws.com/salty-wordpress/salty-wordpress-14-04-vmware-2014-07-12.box"
  end

  config.vm.hostname = "salty-wordpress"
  config.vm.network :private_network, ip: "192.168.50.10"

  config.ssh.forward_agent = true

  config.vm.synced_folder "config", "/home/vagrant/config"
  config.vm.synced_folder "logs", "/srv/logs"
  config.vm.synced_folder "config/salt", "/srv/salt"
  config.vm.synced_folder "dev-plugins", "/dev-plugins"

  config.vm.synced_folder "projects", "/srv/www"

  if File.exists?(File.join(File.dirname(__FILE__),'Customfile')) then
    eval(IO.read(File.join(File.dirname(__FILE__),'Customfile')), binding)
  end

  config.vm.provision :salt do |salt|
    salt.verbose = true
    salt.minion_config = 'config/salt/minions/vagrant.conf'
    salt.run_highstate = true
  end

end
