
import sys
import os
import re

fil = open(os.path.join('c:/', 'squid', 'var', 'log', 'logfile.txt'), 'w')


def modify_url(line):
    l = line.split(" ")
    old_url = l[0]
    new_url = "\n"
    if 'epd-akam-us.oracle.com' in old_url:
        new_url = re.sub(r'(.+)(?=&params)(.+)', r'\1.SQUIDINTERNAL\n', old_url)
    return new_url

while True:
    line = sys.stdin.readline().strip()
    new_url = modify_url(line)
    sys.stdout.write(new_url)
    sys.stdout.flush()
    fil.write(new_url)
    fil.flush()

fil.close()
