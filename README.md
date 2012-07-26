#Quick Start

##Install Librarian

	sudo gem install librarian --no-rdoc --no-ri

##VirtualBox with Vagrant

###Install VirtualBox

Follow the VirtualBox documentation to install VirtualBox if not already installed.

###Install Vagrant

	sudo gem install vagrant --no-rdoc --no-ri

###Run with Vagrant

	cd vagrant
	vagrant box add linux_server ~/Binaries/vagrant/boxes/preciese64.box
	vagrant up

##Directories in repository

cookbooks/			Librarian stored (cached) upstream cookbooks from Cheffile.
examples/			Examples folder for Chef, Chef Solo.
librarian/			Librarian folder for Cheffile templates.
vagrant/			Vagrant project folder

#Updating cookbooks

librarian-chef install