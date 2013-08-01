Vagrant::Config.run do |config|

  # name of vagrant box
  config.vm.box = "linux_server"

  # chef-solo provisioning
  config.vm.provision :chef_solo do |chef|
    #chef.log_level = :debug
    chef.cookbooks_path = File.join(Dir.pwd, 'cookbooks')
    chef.json.merge!(JSON.parse(File.read(File.join(Dir.pwd, 'node.json'))))
    chef.run_list = JSON.parse(File.read(File.join(Dir.pwd, 'node.json')))['run_list']
    #chef.run_list = []
  end

end