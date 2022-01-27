require 'json'

Vagrant.configure("2") do |config|

  config.vm.define "gitlab" do |gitlab|
    env = JSON.parse(File.read("./repository/setup/gitlab/env.json"))

    gitlab.vm.box = "debian/buster64"
    gitlab.vm.hostname = "gitlab.local.nsa"

    gitlab.vm.network :private_network, ip: "192.168.56.80"
    gitlab.vm.network :forwarded_port, guest: 80, host: 8000

    gitlab.vm.provider "virtualbox" do |vb|
      vb.name = "GitLab Server"
      vb.memory = "5048"
      vb.cpus = "2"
    end

    gitlab.vm.provision "file", source: "./repository/setup/gitlab/requirements.txt", destination: "/home/vagrant/requirements.txt"
    gitlab.vm.provision "file", source: "./repository/setup/gitlab/gitlab.rb", destination: "/tmp/gitlab.rb"
    gitlab.vm.provision "shell", path: "./repository/setup/gitlab/provision.sh", env: {
      "CI_TOKEN" => env["CI_TOKEN"],
      "ROOT_PASSWORD" => env["ROOT_PASSWORD"],
      "GITLAB_RUNNER_URL" => env["GITLAB_RUNNER_URL"]
    }
  end

  config.vm.define "backend" do |backend|
    backend.vm.box = "debian/buster64"
    backend.vm.hostname = "backend.local.nsa"

    backend.vm.network :private_network, ip: "192.168.56.81"
    backend.vm.network :forwarded_port, guest: 80, host: 8001

    backend.vm.provider "virtualbox" do |vb|
      vb.name = "backend"
    end
  end

  config.vm.define "frontend" do |frontend|
    frontend.vm.box = "debian/buster64"
    frontend.vm.hostname = "frontend.local.nsa"

    frontend.vm.network :private_network, ip: "192.168.56.83"
    frontend.vm.network :forwarded_port, guest: 80, host: 8003

    frontend.vm.provider "virtualbox" do |vb|
      vb.name = "Frontend"
      vb.memory = "4048"
    end

    frontend.vm.provider "virtualbox" do |vb|
      vb.name = "frontend"
    end
  end

  config.vm.define "database" do |database|
    database.vm.box = "debian/buster64"
    database.vm.hostname = "database.local.nsa"

    database.vm.network :private_network, ip: "192.168.56.82"
    database.vm.network :forwarded_port, guest: 80, host: 8002

    database.vm.provider "virtualbox" do |vb|
      vb.name = "database"
    end
  end
end
