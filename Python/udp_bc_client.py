import  socket

dest = ('<broadcast>', 12345)
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
s.sendto(bytes('Hello', 'utf-8'), dest)
while 1:
    (buf, address) = s.recvfrom(1024*8)
    if not len(buf):
        break;
    print("Receive from %s:%s" % (address, buf))
