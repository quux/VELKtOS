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
name=Elasticsearch repository for 1.2.x packages
baseurl=http://packages.elasticsearch.org/elasticsearch/1.2/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
EOF

#yes -n yum update

# node
yum -y install vim exim  wget java-1.7.0-openjdk
yum -y remove postfix java-1.6.0-openjdk
yum -y install elasticsearch nginx logstash




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

# make sure services starts
/sbin/chkconfig --levels 345 elasticsearch on
/sbin/chkconfig --levels 345 nginx on

# start
/sbin/service elasticsearch start
/sbin/service nginx start



# make sure the mail goes to us
sed -i '/root:/c\root:root@purecobalt.com' /etc/aliases