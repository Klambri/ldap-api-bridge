create-vm:
	VAGRANT_CWD=$(CURDIR)/test/vagrant vagrant up

destroy-vm:
	VAGRANT_CWD=$(CURDIR)/test/vagrant vagrant destroy -f