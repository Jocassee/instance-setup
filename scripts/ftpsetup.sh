USERNAME='awsftpuser'
PASSWORD='SecurePass01'

sudo yum update -y
sudo yum install vsftpd -y

#disable anonymous login to FTP
sudo sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf
IP=$(curl ifconfig.me)
#add configuration items to the bottom of vstpd config file
cat <<EOF | sudo tee --append /etc/vsftpd/vsftpd.conf
pasv_enable=YES
pasv_min_port=1024
pasv_max_port=1048
pasv_address=$IP
EOF
#restart service after changes
sudo systemctl restart vsftpd
#create user
sudo useradd $USERNAME
#set password
echo $PASSWORD | sudo passwd --stdin $USERNAME
#remove comment tag on chroot user setting
sudo sed -i 's/#chroot_local_user=YES/chroot_local_user=YES/g' /etc/vsftpd/vsftpd.conf
#set home folder for user
sudo usermod -d /etc/httpd/ $USERNAME
#add user to root group for complete permuissionset in /etc/httpd/
sudo usermod -a -G root $USERNAME
#restart vsftpd service after changes
sudo systemctl restart vsftpd
#set vsftpd service to start when server boots
sudo chkconfig --level 345 vsftpd on
