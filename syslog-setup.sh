file1="/etc/default/grub"
file2="/etc/rsyslog.conf"
file3="/etc/logrotate.d/rsyslog"
key1="GRUB_CMDLINE_LINUX_DEFAULT"
delimiter1="="
newvalue1='"elevator=noop"'
udp1='module(load="imudp")'
udp2='input(type="imudp" port="514")'
tcp1='module(load="imtcp")'
tcp2='input(type="imtcp" port="514")'

cp "$file1" "$file1.orig"
sed -i "s/\($key1 *= *\).*/\1$newvalue1/" $file1

cp "$file2" "$file2.orig"
sed -i "/^#$udp1/ c$udp1" $file2
sed -i "/^#$udp2/ c$udp2" $file2
sed -i "/^#$tcp1/ c$tcp1" $file2
sed -i "/^#$tcp2/ c$tcp2" $file2

wget "https://raw.githubusercontent.com/StaxMclean/SentinelTest/master/rsyslog.new"

cp "$file3" "$file3.orig"
cp rsyslog.new "$file3"

ufw allow 514/tcp
ufw allow 514/udp

update-grub2

apt install -y python