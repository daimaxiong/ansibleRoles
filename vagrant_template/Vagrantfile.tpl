Vagrant.require_version ">= 1.8.0"
require 'yaml'
config=YAML.load_file("config.yml")

VAGRANT_API_VERSION = "2"
PRIVATE_NETWORK_IP = config['vagrant']['box']['ip']
BOX_NAME = config['vagrant']['box']['name']
BOX_IMAGE = config['vagrant']['box']['image']
BOX_MEMORY = config['vagrant']['box']['memory']
BOX_CPU = config['vagrant']['box']['cpus']

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = BOX_IMAGE
  config.vm.define BOX_NAME
  config.vm.provider "virtualbox" do |v|
     v.customize ["modifyvm", :id, "--memory", BOX_MEMORY]
     v.customize ["modifyvm", :id, "--cpus", BOX_CPU]
  end
  
  config.vm.network "private_network", ip: PRIVATE_NETWORK_IP

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.limit="all"
    ansible.playbook = "./playbook.yml"
  end
end
