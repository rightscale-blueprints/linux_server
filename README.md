#Quick Start

##RightScale

The latest revision (always tested) is available in the RightScale Marketplace with the RightScale Linux Server RL 5.8 ServerTemplate (http://www.rightscale.com/library/server_templates/RightScale-Linux-Server-RL-5-8/lineage/15982).

Simply import the ServerTemplate from the marketplace, add a server to a deployment and launch!

##VirtualBox with Vagrant

###Install VirtualBox

Follow the VirtualBox documentation to install VirtualBox if not already installed.

###Install Vagrant

	sudo gem install vagrant --no-rdoc --no-ri

###Clone the linux_server Blueprint

	mkdir -p ~/src/github/rightscale-blueprints
	cd ~/src/github/rightscale-blueprints
	git clone git://github.com/rightscale-blueprints/linux_server.git
	cd linux_server/vagrant

###Run with Vagrant

Already up'd a linux_server box?

	#vagrant status                   # check vm status
	#vagrant reload                   # reload the vm
	#vagrant suspend                  # suspend the vm
	#vagrant halt                     # power down the vm
	#vagrant destroy                  # destroy the vm
	#vagrant box remove linux_server  # remove the box

Add a new box from local or remote (Ubuntu 12.04)

	vagrant box add linux_server http://files.vagrantup.com/precise64.box
	#vagrant box add linux_server ~/Binaries/vagrant/boxes/precise64.box

Need debug?

	VAGRANT_LOG=debug

Run the virtual machine

	# vagrant up!
	vagrant up
	
This uses the Vagrantfile in the vagrant/ folder (and the examples/chef-solo/node.json for the Chef Solo provisioning).

#Using Librarian

##Install Librarian

	sudo gem install librarian --no-rdoc --no-ri

##Updating cookbooks

To refresh the cookbooks in cookbooks/ per the Cheffile, run the following:

	librarian-chef install
	
#Erata

##Directories in this repository

	cookbooks/			Librarian stored (cached) upstream cookbooks from Cheffile.
	examples/			Examples folder for Chef, Chef Solo.
	librarian/			Librarian folder for Cheffile templates.
	vagrant/			Vagrant project folder