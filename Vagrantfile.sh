Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  config.vm.provision "shell", inline: <<-SHELL	
   sudo apt-get update
   sudo apt-get install unzip
   sudo apt-get install php5 php5-dev apache2 -y
   sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 1234'
   sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 1234'
   sudo apt-get -y install mysql-server mysql-client
   cd /var/www/html && sudo wget https://github.com/berksudan/phpapp/archive/master.zip 
   sudo unzip master.zip && sudo mv phpapp-master/* . 
   sudo rm -rv phpapp-master master.zip index.html
   sudo mysql -u root -p1234 -e 'create database db'
   sudo mysql -u root -p1234 -e 'grant all privileges on db.* to 'root'@'localhost' identified by "1234"'
   sudo mysql -u root -p1234 db < /var/www/html/schema.sql -v
SHELL
end	 
