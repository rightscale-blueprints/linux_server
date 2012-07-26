#Quick Start

##RightScale

TBR on the forthcoming RightScale Linux Server RL 5.8 ServerTemplate.

##Install Librarian

	sudo gem install librarian --no-rdoc --no-ri

##VirtualBox with Vagrant

###Install VirtualBox

Follow the VirtualBox documentation to install VirtualBox if not already installed.

###Install Vagrant

	sudo gem install vagrant --no-rdoc --no-ri

###Run with Vagrant

Run the following commands to launch a new virtual machine with Vagrant:

	cd vagrant
	vagrant box add linux_server http://files.vagrantup.com/precise64.box
	#vagrant box add ~/Binaries/vagrant/boxes/precise64.box
	vagrant up

##Directories in repository

	cookbooks/			Librarian stored (cached) upstream cookbooks from Cheffile.
	examples/			Examples folder for Chef, Chef Solo.
	librarian/			Librarian folder for Cheffile templates.
	vagrant/			Vagrant project folder

#Updating cookbooks

	librarian-chef install