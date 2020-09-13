# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
 
  config.vm.provision "ansible" do |ansible|
    #ansible.galaxy_role_file = "tests/requirements.yml"
    ansible.config_file = "tests/ansible.cfg"
    ansible.playbook = 'tests/test.yml'
    ansible.groups = {
      "localhost" => ["default"]
    }
    ansible.become = true
    ansible.extra_vars = {
      ansible_python_interpreter: '/usr/bin/python3',
    }
  end

  config.vm.provision :serverspec do |spec|
    spec.pattern = 'tests/serverspec/*-spec.rb'
    #spec.html_output = true
    #spec.junit_output = true
    #spec.junit_output_file = 'junit.xml'
  end
end
