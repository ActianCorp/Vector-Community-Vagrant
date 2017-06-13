# Vector Community Edition installation using Vagrant

This Vagrant 'package' will configure a Centos 7.3 Linux box with the Community edition of Vector installed and running. Additionally, the DBT3 benchmark data will be installed and run.

The essential files are:

    1. Vagrantfile
    2. actian-user.rb (Chef script)
    3. vector-install.rb (Chef script)

To achieve this there are certain mandatory pre-requisites that must be fulfilled:

    1. Install Vagrant (Version 1.9.5 used constructing the above)
    2. Install Oracle Virtual Box (5.0.4 or later)
    3. Enable hardware virtualisation in the BIOS if it is disabled.
    4. (optional) install the 'cachier' vagrant package to save on downloads via
        vagrant plugin install cachier

This package was tested using Vagrant 1.9.5, CentOS 7.3 and Oracle Virtual Box 5.1.22 / Microsoft
Azure free trial.

## Using Microsoft Azure as the VM provider

This package by default uses Oracle Virtual Box as the VM provider by default.
However,  it is also configured to be used with the Microsoft Azure cloud service.
    e.g. vagrant up --provider=azure

To use the Azure provider, two additional Vagrant installs are required. Commands are:

    1. vagrant plugin install vagrant-azure
    2. vagrant box add azure https://github.com/msopentech/vagrant-azure/raw/master/dummy.box

First thing to know is that unlike Virtual Box you can't have a Vagrant file for the Azure provider that works for everyone. There are details specific to you and you only these being:

    1. Your Azure Subscription ID;
    2. Your certificate:
        - The .pem file.

A separate illustrated MS Word document is available to guide you through the Azure subscription process and how to setup Azure and the Vagrant file changes required which are related to your personal subscription.

## Usage

To get your Vector installation up and running:

    1. Download the Actian Vector Community installation package from here : [http://www.actian.com/lp/vector-community-edition](http://www.actian.com/lp/vector-community-edition)
    2. Create a directory for the project, e.g. "c:\Vector"
    3. Into this directory copy the files in this package, the Vector Community installation package e.g. actian-vector-5.0.0-405-community-linux-x86_64.tgz.
    4. From a command prompt in the directory you created run "vagrant up".

A terminal screen will be displayed for the Virtual Box VM created. For Azure, see the associated Word document on a suggested terminal access method.

The complete configuration for Virtual Box can take up to 5 minutes dependent on the speed of your network.  If using the Microsoft Azure provider be patient as in the author's experience it can take a little longer!

When complete, either logon directly to the VM as User: actian, Password : actian

Or else you can use "vagrant ssh" to get a shell as the 'vagrant' user. If you want to use Vector then you should 'su - actian' to be able to use the Vector tools. If you hit a problem with vagrant ssh, see the Notes section below for a troubleshooting tip.

At this point the Vector environment is fully configured for you to use.

The DBT3 test scripts have been run. The following output files are applicable:

    1. Run log - /tmp/load-run-dbt3-benchmark.log
    2. Run results - /home/actian/VectorH-DBT3-Scripts/run_performance.out


## NOTES

If installing under Windows 10, you may hit problems with Vagrant and Virtual Box in being able to SSH into the created VM if there is a space in the pathname. The workaround for this is to use this as way to start an SSH shell, instead of simply using 'vagrant ssh':

`vagrant ssh-config > vagrant-ssh-config && ssh -A -F vagrant-ssh-config default`

This command can be placed into your .bashrc or created as an alias for convenience, e.g.:

```vagrant() {
  if [[ $@ == "ssh" ]]; then
    command vagrant ssh-config > vagrant-ssh-config && ssh -A -F vagrant-ssh-config default
  else
    command vagrant "$@"
  fi
}
```

The approach to using 'Chef' in the Vagrantfile may seem strange as the installation and chef-apply are performed via the "config.vm.provision 'shell' ....".
This was intentional to create a generic script that would work for providers Oracle Virtual Box and Azure.
Using Azure 'chef_apply' will fail installing Chef. Even when Chef is manually installed to circumvent this, it will then fail applying a Recipe even though it appears to complete successfully.
