#!/bin/bash

# 函数：查询防火墙状态和开放的端口
check_firewall() {
    # 检查防火墙状态
    if command -v systemctl &> /dev/null; then
        echo "当前防火墙状态："
        systemctl status firewalld && echo ""
    elif command -v ufw &> /dev/null; then
        echo "当前防火墙状态："
        ufw status verbose && echo ""
    else
        echo "未安装支持的防火墙软件"
        exit 1
    fi

    # 查询开放的端口
    echo "已开放的端口："
    if command -v firewall-cmd &> /dev/null; then
        firewall-cmd --list-ports
    elif command -v ufw &> /dev/null; then
        ufw status numbered
    fi
}

# 主菜单
main_menu() {
    echo "请选择要执行的操作："
    echo "1. 开放防火墙端口"
    echo "2. 关闭防火墙"
    echo "3. 查询当前防火墙状态和开放的端口"
    echo "4. 退出"

    read -p "输入选项编号: " option

    case $option in
        1) open_firewall_port ;;
        2) close_firewall ;;
        3) check_firewall ;;
        4) echo "退出..." && exit 0 ;;
        *) echo "无效的选项" && main_menu ;;
    esac
}

# 开放防火墙端口
open_firewall_port() {
    read -p "请输入要开放的端口号（格式：端口号/协议，例如：80/tcp）: " port
    if command -v firewall-cmd &> /dev/null; then
        sudo firewall-cmd --permanent --add-port=$port
        sudo firewall-cmd --reload
        echo "端口 $port 已成功开放"
    elif command -v ufw &> /dev/null; then
        sudo ufw allow $port
        echo "端口 $port 已成功开放"
    else
        echo "未安装支持的防火墙软件"
        exit 1
    fi
}

# 关闭防火墙
close_firewall() {
    if command -v systemctl &> /dev/null; then
        sudo systemctl stop firewalld
        sudo systemctl disable firewalld
        echo "防火墙已关闭"
    elif command -v ufw &> /dev/null; then
        sudo ufw disable
        echo "防火墙已关闭"
    else
        echo "未安装支持的防火墙软件"
        exit 1
    fi
}

# 主程序
main_menu
