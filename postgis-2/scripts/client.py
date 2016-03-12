#!/usr/bin/python

import socket
import sys
import argparse


def setup(address):
    # Create a UDS socket
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

    print >>sys.stderr, 'connecting to %s' % address
    try:
        sock.connect(address)
    except socket.error, msg:
        print >>sys.stderr, msg
        sys.exit(1)

    return sock


def send(sock, message, response):
    try:
        # Send data
        print >>sys.stderr, 'sending "%s"' % message
        sock.sendall(message)

        amount_received = 0
        amount_expected = len(response)

        while amount_received < amount_expected:
            data = sock.recv(16)
            amount_received += len(data)
            print >>sys.stderr, 'received "%s"' % data
            if data == response:
                exit_code = 0
            else:
                exit_code = 1

    finally:
        print >>sys.stderr, 'closing socket'
        sock.close()
        sys.exit(exit_code)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--address', required=True, help='the socket server path')
    parser.add_argument('--send_msg', required=True, help='data to send')
    parser.add_argument('--except_msg', required=True, help='data to except')
    args = parser.parse_args()
    sock = setup(args.address)
    send(sock, args.send_msg, args.except_msg)
