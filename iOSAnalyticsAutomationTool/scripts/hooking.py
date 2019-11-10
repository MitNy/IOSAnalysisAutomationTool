import frida
import sys
import time

def on_message(message, data):
    try:
        if message:
            print("[log] {0}".format(message["payload"]))
    except Exception as e:
        print(message)
        print(e)

def do_hook(path):
    with open(path, 'r') as f:
        hook = f.read()
    print(hook)

    return hook

if __name__ == '__main__' :
    # ./hooking.py APP_NAME JS_FILE
    app_name_or_id = sys.argv[1]
    JS_PATH = sys.argv[2]
    try :
        print ("[log] devices info : {}".format(frida.get_device_manager().enumerate_devices()))
        device = frida.get_device_manager().enumerate_devices()[-2]
        try:
            app = next(app for app in device.enumerate_applications() if
                       app_name_or_id == app.identifier or
                       app_name_or_id == app.name)
        except:
            print('app "%s" not found' % app_name_or_id)
            sys.exit(-1)

        pid = device.spawn([app.identifier])
        print ("[log] {} is starting. (pid : {})".format(app_name_or_id, pid))

        session = device.attach(pid)
        device.resume(pid)

        script = session.create_script(do_hook(JS_PATH))
        script.on('message', on_message)
        script.load()
        print ("[log] Done. The hooking process will be terminated in 5 seconds...")
        time.sleep(5)
    except KeyboardInterrupt:
        sys.exit(0)
