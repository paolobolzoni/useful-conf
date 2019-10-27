#!/usr/bin/env python3

import subprocess
import sys
import time



def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def main():
    nr_fast = 3
    time_length = 0.
    while nr_fast > 0:
        time.sleep( min(time_length, 10.) )

        eprint('syncing... ', end='', flush=True)
        start_t = time.time()
        subprocess.Popen('/usr/bin/sync', stdout=None, stderr=None).wait()
        time_length = time.time() - start_t
        eprint('{0:0.3f}'.format(time_length))

        if time_length < 0.03:
            nr_fast = nr_fast - 1
        else:
            nr_fast = 3

    return 0

if __name__ == '__main__':
    sys.exit(main())

