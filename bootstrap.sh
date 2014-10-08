#/bin/bash

#bootstrap vagrant centos 6 client machine for dev 

# epel
yum -y install http://fedora.mirror.nexicom.net/epel/6/i386/epel-release-6-8.noarch.rpm

rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch


cat << EOF > /etc/yum.repos.d/logstash.repo
[logstash-1.4]
name=logstash repository for 1.4.x packages
baseurl=http://packages.elasticsearch.org/logstash/1.4/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
[elasticsearch-1.0]
name=Elasticsearch repository for 1.3.x packages
baseurl=http://packages.elasticsearch.org/elasticsearch/1.3/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
EOF

#yes -n yum update

# node
yum -y install vim wget java-1.7.0-openjdk
yum -y remove java-1.6.0-openjdk
yum -y install elasticsearch nginx logstash


cat << EOF >> /etc/default/elasticsearch
ES_HEAP_SIZE=512m
MAX_OPEN_FILES=65535
MAX_LOCKED_MEMORY=unlimited
EOF

# limits
echo "elasticsearch - nofile 65535" >> /etc/security/limits.conf
echo "elasticsearch - memlock unlimited" >> /etc/security/limits.conf

# allow memlock
echo "bootstrap.mlockall: true" >> /etc/elasticsearch/elasticsearch.yml

# nginx setup
cat << EOF > /etc/nginx/conf.d/default.conf
server {
    listen       80 default_server;
    server_name  _;

   
    location / {
        #root   /usr/share/nginx/html;
        root /usr/share/kibana;
        index  index.html index.htm;
    }

  
}
EOF

# kibana
wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.1.tar.gz
tar xzf kibana-3.1.1.tar.gz
mv kibana-3.1.1/ /usr/share/kibana
rm kibana-3.1.1.tar.gz

# make sure services starts
/sbin/chkconfig --levels 345 elasticsearch on
/sbin/chkconfig --levels 345 nginx on

# fix path
sed -i '/PATH=/c\PATH=$PATH:$HOME/bin:/opt/logstash/bin' /home/vagrant/.bash_profile
sed -i '/PATH=/c\PATH=$PATH:$HOME/bin:/opt/logstash/bin' /etc/skel/.bash_profile

# start
/sbin/service elasticsearch start
/sbin/service nginx start



