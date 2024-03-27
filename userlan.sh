#!/bin/bash

# 设置变量
username="userlan"
password="ATJd3MwwUDbjwFgUJe3oo"

# 检查发行版
if [ -f /etc/redhat-release ]; then
    distro="centos"
elif [ -f /etc/debian_version ]; then
    distro="debian"
elif [ -f /etc/os-release ]; then
    if grep -q "Ubuntu 20" /etc/os-release; then
        distro="ubuntu20"
    elif grep -q "Ubuntu 22" /etc/os-release; then
        distro="ubuntu22"
    else
        echo "未知的Ubuntu版本"
        exit 1
    fi
else
    echo "未知的发行版"
    exit 1
fi

# 添加用户
if [ "$distro" = "centos" ]; then
    sudo useradd -m $username
elif [ "$distro" = "debian" ]; then
    sudo adduser --disabled-password --gecos "" $username
elif [ "$distro" = "ubuntu20" ] || [ "$distro" = "ubuntu22" ]; then
    sudo adduser --disabled-password --gecos "" $username
fi

# 设置密码
echo "$username:$password" | sudo chpasswd

# 将用户添加到root组
if [ "$distro" = "centos" ]; then
    sudo usermod -aG wheel $username
elif [ "$distro" = "debian" ] || [ "$distro" = "ubuntu20" ] || [ "$distro" = "ubuntu22" ]; then
    sudo usermod -aG sudo $username
fi

echo "用户$userlan已创建，并已添加到root用户组。"
