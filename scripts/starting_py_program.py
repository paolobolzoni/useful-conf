
import sys

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def main(argv=None):
    if argv is None:
        argv = sys.argv
    return 0

if __name__ == "__main__":
    sys.exit(main())
