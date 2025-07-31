#!/usr/bin/python
# coding=utf-8
import os
import sys
import time
import re
import subprocess
import socket


def printc(data, color="green"):
    """
    高亮颜色打印输出功能
    :param data: 打印内容
    :param color: 指定颜色, 默认为绿色(32)
    :return:
    """
    color_dict = {
        "black": 30,
        "red": 31,
        "green": 32,
        "yellow": 33,
        "blue": 34,
        "purple": 35,
        "cyan": 36,
        "white": 37,
    }
    if color not in color_dict:
        color = "green"
    color = color_dict[color]
    print(f"\033[1;{color}m{data}\033[0m")

def nu_searcher(pattern, file_path):
    '''
    行号搜索器
    :param pattern: 搜索内容
    :param file_path: 搜索文件路径
    :return: 搜索到内容的行号,如果没有找到匹配的行,返回None
    '''
    with open(file_path, 'r', encoding='utf-8') as file:
        for line_number, line_content in enumerate(file, 1):
            if re.search(pattern, line_content):
                return line_number
    return None



def port_scanner(ip, port):
    '''
    :param ip: 要扫描的IP地址
    :param port: 要扫描的端口号
    :return: 返回命令的退出状态 (类似于echo $?)
    '''
    command = f"nc -n -w2 -z {ip} {port}"
    result = subprocess.run(command, shell=True, capture_output=True)
    return result.returncode


def check_service_status(method, service_name=None, port=None):
    '''
    :param method: 通过ss或ps命令检查服务状态
    :param service_name: 要匹配的服务名称,内置字典，可以选择不写默认端口号
    :param port: 要匹配的端口号
    :return: 无返回值, 输出相关信息
    '''
    # 内置服务与端口字典
    service_port_map = {
        "sshd": "22",
        "httpd": "80",
        "nginx": "80",
        "mysqld": "3306",
        "dhcpd": "67",
        "named": "53",
        "bind": "53",
        "vsftpd": "21",
        "rpcbind": "111",
    }
    
    if service_name and service_name in service_port_map:
        port = service_port_map[service_name]
    
    if method == "ss":
        if not port:
            printc("未提供端口号或服务名", "red")
            return
        
        # 使用 ss -atunp 检查端口是否开启, 确保精确匹配
        ss_result = subprocess.run(['ss', '-atunp'], stdout=subprocess.PIPE, text=True)
        if re.search(rf"\b{port}\b", ss_result.stdout):
            printc(f"{service_name} 服务端口:{port} 开启成功", "green")
        else:
            printc(f"{service_name} 服务端口:{port} 开启失败, 请检查相关配置文件", "red")
    
    elif method == "ps":
        if not service_name:
            printc("未提供服务名", "red")
            return
        
        # 使用 ps aux 检查服务是否在运行
        ps_result = subprocess.run(['ps', 'aux'], stdout=subprocess.PIPE, text=True)
        if re.search(rf"\b{service_name}\b", ps_result.stdout):
            printc(f"{service_name} 服务在运行中", "green")
        else:
            printc(f"{service_name} 服务未在运行中, 请检查相关配置文件", "red")
    else:
        printc(f"未知检查方法 {method}, 请检查输入", "red")


def log_message(message):
    printc(f"Log: {message}", "yellow")


def handle_error(error):
    printc(f"Error: {error}", "red")
    sys.exit(1)




 