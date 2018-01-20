Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :private_network, ip: "192.168.222.222"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1536
    vb.cpus = 2
  end

  # Fix error stdin no tty
  #
  config.vm.provision "fix-no-tty", type: "shell" do |shell|
    shell.privileged = false
    shell.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision :shell, path: "scripts/install_nodejs.sh"
  config.vm.provision :shell, path: "scripts/install_rvm.sh", args: "stable", privileged: false
  config.vm.provision :shell, path: "scripts/install_gems.sh", args: "2.4.0 rails", privileged: false
end
