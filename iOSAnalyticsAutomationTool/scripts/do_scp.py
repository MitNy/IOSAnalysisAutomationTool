
#!/usr/bin/env python
# encoding: utf-8

from paramiko import SSHClient, AutoAddPolicy
from scp import SCPClient
import sys

def scp_file(src, dest):
    ssh = SSHClient()
    ssh.set_missing_host_key_policy(AutoAddPolicy())
    ssh.connect('localhost', port=2222, username='root', password='alpine')
    scp = SCPClient(ssh.get_transport())
    scp.put(src, dest)
    
    scp.close()
    ssh.close()

if __name__ == '__main__' :
    src = sys.argv[1]
    dest = sys.argv[2]
    scp_file(src, dest)
