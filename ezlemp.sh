#! /bin/bash

updateMachine()
{
        sudo apt update -y && sudo apt upgrade -y
}

getNginx()
{
        sudo apt install nginx -y
}

secureServ()
{
        sudo ufw allow 'Nginx Full' && sudo ufw allow OpenSSH && sudo ufw enable && echo "Nginx added to UFW rules" && sudo ufw status
        sudo apt install fail2ban -y
}

getDns()
{
        echo "Please enter your domain here (ex: mydomain.com) or your servers IP if you do not have a domain"
        read DNS
}

getMysql()
{
        sudo apt install mysql-server -y
}

getPhp()
{
        sudo apt install php8.0-fpm php8.0-mysql -y
}

makeConfig()
{
        sudo mkdir /var/www/$DNS
        sudo chown -R $USER:$USER /var/www/$DNS
        sed -i "s/EDIT/$DNS/g" configs/NginxConfig && cat configs/NginxConfig >> /etc/nginx/sites-available/$DNS
        sudo ln -s /etc/nginx/sites-available/$DNS /etc/nginx/sites-enabled/ && sudo unlink /etc/nginx/sites-enabled/default
        sudo nginx -t && sudo systemctl reload nginx
}

makeIndex()
{
        sed -i "s/EDIT/$DNS/g" configs/index.html && cat configs/index.html >> /var/www/$DNS/index.html
        cat configs/info.php >> /var/www/$DNS/info.php
}
echo "Welcome to ezStack, the auto stack config script. Currently installing the L.E.M.P stack"
updateMachine && getNginx && secureServ && getDns && getMysql && getPhp && makeConfig && makeIndex && echo "Congratulations, L.E.M.P installed successfully."

