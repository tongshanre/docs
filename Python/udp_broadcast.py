import socket, traceback

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
s.bind(('', 12345))
while 1:
    try:
        message,addr = s.recvfrom(1024*8)
        print('Got data from:', addr)
        s.sendto(bytes('I am here', 'utf-8'), addr)
    except Exception as e:
        traceback.print_exc(e)
