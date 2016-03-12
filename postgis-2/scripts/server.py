#!/usr/bin/python

import socket
import sys
import os
import argparse


def validations(address):

    # Make sure the socket does not already exist
    try:
        os.unlink(address)
    except OSError:
        if os.path.exists(address):
            raise


def setup(address):
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    # Bind the socket to the port
    print >>sys.stderr, 'starting up on %s' % address
    sock.bind(address)

    # Listen for incoming connections
    sock.listen(1)
    return sock


def loop(sock, except_msg, response):
    connection, client_address = sock.accept()
    try:
        # Receive the data in small chunks and retransmit it
        while True:
            data = connection.recv(16)
            if data:
                print >>sys.stderr, 'received "%s"' % data
                if data == except_msg:
                    print >>sys.stderr, 'response ', response
                    connection.sendall(response)
                    exit_code = 0
                else:
                    print 'unknown message!'
                    exit_code = 1
            else:
                exit_code = 1
                break

    finally:
        connection.close()
        sys.exit(exit_code)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--address', required=True, help='the socket server path')
    parser.add_argument('--except_msg', required=True, help='data to except')
    parser.add_argument('--response_msg', required=True, help='data to send')
    args = parser.parse_args()
    validations(args.address)
    sock = setup(args.address)
    loop(sock, args.except_msg, args.response_msg)
