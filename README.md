# VELKtOS

Vagrant - Elasticsearch - Logstash - Kibana - CentOS

VELKtOS is an open source Vagrant configuration for running an ELK stack locally. 

## Requirements

- Vagrant
- Vagrant chef/centos-6-5 box: `vagrant init chef/centos-6.5`

## How to use

- `git clone https://github.com/quux/VELKToS.git`
- Review the `Vagrantfile` and adjust to taste
- `vagrant up`
- Time for tea 
- Point your browser to `http://192.168.192.168/`

You are now ready to head over to the [logstash docs](http://logstash.net/docs/1.4.2/) and write your first input job.
