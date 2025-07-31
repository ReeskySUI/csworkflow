#!/bin/bash


function baseinstall(){
echo "install local dnf meta..."
mkdir /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/
touch /etc/yum.repos.d/local.repo
cat >/etc/yum.repos.d/local.repo <<EOF
[baseos]
name=BaseOS
baseurl=file:///media/BaseOS
gpgcheck=0
enabled=1

[appstream]
name=AppStream
baseurl=file:///media/AppStream
gpgcheck=0
enabled=1
EOF


echo "remake dnf repo..."
dnf clean all &>/dev/null
dnf makecache &>/dev/null


echo "insatll normal software..."
dnf install -y vim bash* tree net-tools bzip2 nmap gcc zip pcre-devel zlib-devel postfix s-nail traceroute lrzsz bind-utils PackageKit-command-not-found polkit &> /dev/null

}

# scp root@192.168.50.15:/root/test/baseset.sh ./

#光盘挂载
echo "BasicSettings Workflow"
echo "---check CD---"
df -h | grep "sr0"  &> /dev/null
if [ $? -eq 0 ]
then
    echo "sr0 is already"
else
    echo "sr0 is not already .. begin mount"
    read -p "please enter you want to mount directory:" mntdir
    echo "/dev/sr0                                  $mntdir                  iso9660 defaults        0 0" >> /etc/fstab
    mount -a &>/dev/null
    echo "SR0 is already be mounted"
    systemctl daemon-reload
    lsblk | grep sr0
    unset mntdir
fi
echo "---1/6---"

echo "check local meta"
while :
do
[ -e /etc/yum.repos.d/local.repo ] && echo "/etc/yum.repos.d/local.repo is exist , skip or not?" && read -p "(y|n|look)" yon || yon=n ; echo "local meta is not already ,now is going to insatll..." 
case $yon in 
n)
echo "continue install"
baseinstall
unset yon
break
;;
y)
echo "cancer install"
unset yon
break
;;
look)
cat /etc/yum.repos.d/local.repo
esac
done
echo "---2/6---"

# 永久关闭防火墙
echo "close & disable firewall"
systemctl stop firewalld
systemctl disable firewalld
echo "---3/6---"

# 永久关闭selinux
sed -i 's/enforcing$/disabled/g' /etc/selinux/config
echo "forever close selinux"
echo "---4/6---"


# 添加shell类型
echo /sbin/nologin >> /etc/shells 
echo "add shells"
echo "---5/6---"

# 修改网卡配置
# 查看网卡配置
echo "Be going to set your network interface card configerations ,please be sure of your cardname & ip(/mask,gw)"

echo "All network interface card status"
ip a
# echo "已有配置文件"
# already="/etc/NetworkManager/system-connections/*"

netname=()
netaddr=()
echo -e "\e[31mPlease make sure that the next input is correct, as I don't have a checksum mechanism!!!\nYou can enter more than one line but separate them with spaces\e[0m"
read -p "please enter your NIC: " -a netname
read -p "please enter your network interface card (IP/MASK,GW) address=" -a netaddr
# read -p "请输入你的NAT网卡名称:" netarray[2]
# read -p "请输入你的NAT网卡后两位IP:" netarray[3]


for i in `seq ${#netname[*]}`
do
if [ -e /etc/NetworkManager/system-connections/${netname[$i-1]}.nmconnection ]
then 
linenum=`cat -n /etc/NetworkManager/system-connections/${netname[$i-1]}.nmconnection | egrep "\[ipv4\]" | awk '{print $1}'`
lastnum=`cat -n /etc/NetworkManager/system-connections/${netname[$i-1]}.nmconnection | egrep "\[ipv6\]" | awk '{print $1}'`
sed -i ''$((linenum+1))','$((lastnum-1))'d' /etc/NetworkManager/system-connections//${netname[$i-1]}.nmconnection
sed -i ''$linenum'a method=manual\naddress1='${netaddr[$i-1]}'\n\n' /etc/NetworkManager/system-connections//${netname[$i-1]}.nmconnection
# sed -i ''$linenum'a address1='${netaddr[$i-1]}'' /etc/NetworkManager/system-connections//${netname[$i-1]}.nmconnection
else
touch /etc/NetworkManager/system-connections/${netname[$i-1]}.nmconnection
uuid=`nmcli con show | egrep "${netname[$i-1]}" | awk '{print $2}'`
echo "[connection]
id=${netname[$i-1]}
uuid=$uuid
type=ethernet
autoconnect-priority=-999
interface-name=${netname[$i-1]}

[ethernet]

[ipv4]
address1=${netaddr[$i-1]}
method=manual

[ipv6]
addr-gen-mode=eui64
method=auto

[proxy]" >> /etc/NetworkManager/system-connections/${netname[$i-1]}.nmconnection
fi
# 重新加载并启用配置文件,关闭
nmcli con reload
nmcli con up ${netname[$i-1]}
done

# 输出当前状态
ip a
# 输入要关闭的网卡
read -p "Enter the name of the NAT NIC that you want to disable:" ensname
sed -i 's/manual/disabled/g' /etc/NetworkManager/system-connections/${ensname}.nmconnection

nmcli con reload
nmcli con down $ensname
echo "---6/6---"
ip a

read -p "reboot now? y | anything else  :" yon
[ "$yon" == y ] && reboot || echo -e "\e[33;5mFINISHED\e[0m"





