create-vm:
	VAGRANT_CWD=$(CURDIR)/test/vagrant vagrant up
	VAGRANT_CWD=$(CURDIR)/test/vagrant vagrant ssh -c "sudo reboot"

destroy-vm:
	VAGRANT_CWD=$(CURDIR)/test/vagrant vagrant destroy -f