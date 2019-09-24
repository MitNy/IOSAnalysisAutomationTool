#!/usr/bin/env python
# encoding: utf-8

import frida
import sys


def fatal(reason):
    print(reason)
    sys.exit(-1)


def find_app(app_name_or_id, device_id, device_ip):
    if device_id is None:
        if device_ip is None:
            dev = frida.get_usb_device()
        else:
            frida.get_device_manager().add_remote_device(device_ip)
            dev = frida.get_device("tcp@" + device_ip)
    else:
        try:
            dev = next(dev for dev in frida.enumerate_devices()
                       if dev.id.startswith(device_id))
        except StopIteration:
            fatal('device id %s not found' % device_id)

    if dev.type not in ('tether', 'remote', 'usb'):
        fatal('unable to find device')

    return dev


def main():
    dev = find_app(None, None, None)
    print (dev)


if __name__ == '__main__':
    main()
