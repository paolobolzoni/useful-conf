#!/usr/bin/env python3

import subprocess
import sys
from time import time



def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def main():
    nr_fast = 3
    while nr_fast > 0:
        eprint('syncing... ', end='', flush=True)
        start_t = time()
        subprocess.Popen('/usr/bin/sync', stdout=None, stderr=None).wait()
        time_length = time() - start_t
        eprint('{0:0.3f}'.format(time_length))

        if time_length < 0.10:
            nr_fast = nr_fast - 1
        else:
            nr_fast = 3

    return 0

if __name__ == '__main__':
    sys.exit(main())

