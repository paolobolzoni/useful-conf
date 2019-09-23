#!/usr/bin/env python3

# from __future__ import print_function #(if python2)

import sys
import os


def eprint(*args, **kwargs):
    ''' Just like the print function, but on stderr
    '''
    print(*args, file=sys.stderr, **kwargs)

def main(argv=None):
    ''' Program starting point, it can started by the OS or as normal function

        If it's a normal function argv won't be None if started by the OS
        argv is initialized by the command line arguments
    '''
    if argv is None:
        argv = sys.argv

    return 0

if __name__ == '__main__':
    sys.exit(main())
