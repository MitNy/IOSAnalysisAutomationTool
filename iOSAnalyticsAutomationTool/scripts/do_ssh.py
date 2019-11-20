#!/usr/bin/env python
# encoding: utf-8

from paramiko import SSHClient, AutoAddPolicy
import sys

def cmd_execute_iOS(cmd):
    ssh = SSHClient()
    ssh.set_missing_host_key_policy(AutoAddPolicy())
    ssh.connect('localhost', port=2222, username='root', password='alpine')
    stdin, stdout, stderr = ssh.exec_command(cmd)
    ssh.close()
    return (stdin, stdout, stderr)
    
if __name__ == '__main__' :
    cmd = sys.argv[1]
    cmd_execute_iOS(cmd)
