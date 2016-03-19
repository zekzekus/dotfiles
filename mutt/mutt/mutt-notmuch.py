#!/usr/bin/env python
"""
mutt-notmuch-py

This is a Gmail-only version of the original mutt-notmuch script.

It will interactively ask you for a search query and then symlink the matching
messages to $HOME/.cache/mutt_results.

Add this to your muttrc.

macro index / "<enter-command>unset wait_key<enter><shell-escape>mutt-notmuch-py<enter><change-folder-readonly>~/.cache/mutt_results<enter>" \
          "search mail (using notmuch)"

This script overrides the $HOME/.cache/mutt_results each time you run a query.

Install this by adding this file somewhere on your PATH.

Tested on OSX Lion, OSX El Capitan and Arch Linux.

(c) 2012 - Honza Pokorny
Licensed under BSD
"""

import os
import hashlib

from commands import getoutput
from mailbox import Maildir
from optparse import OptionParser
from collections import defaultdict


def digest(filename):
    with open(filename) as f:
        return hashlib.sha1(f.read()).hexdigest()


def pick_all_mail(messages):
    for m in messages:
        if 'All Mail' in m:
            return m


def empty_dir(directory):
    box = Maildir(directory)
    box.clear()


def command(cmd):
    return getoutput(cmd)


def main(dest_box, options):
    is_gmail = options.gmail
    filter_path = options.base_path
    query = raw_input('Query: ')

    command('mkdir -p %s/cur' % dest_box)
    command('mkdir -p %s/new' % dest_box)

    empty_dir(dest_box)

    files = command('notmuch search --output=files %s' % query).split('\n')

    data = defaultdict(list)
    messages = []

    for f in files:
        if not f:
            continue

        if filter_path is not None and filter_path not in f:
            continue

        try:
            sha = digest(f)
            data[sha].append(f)
        except IOError:
            print('File %s does not exist' % f)

    for sha in data:
        if is_gmail and len(data[sha]) > 1:
            messages.append(pick_all_mail(data[sha]))
        else:
            messages.append(data[sha][0])

    for m in messages:
        if not m:
            continue

        target = os.path.join(dest_box, 'cur', os.path.basename(m))
        if not os.path.exists(target):
            os.symlink(m, target)


if __name__ == '__main__':
    p = OptionParser("usage: %prog [OPTIONS] [RESULTDIR]")
    p.add_option('-g', '--gmail', dest='gmail',
                 action='store_true', default=True,
                 help='gmail-specific behavior')
    p.add_option('-G', '--not-gmail', dest='gmail',
                 action='store_false',
                 help='Normal, non-gmail-specific behavior')
    p.add_option('-p', '--base-path', dest='base_path',
                 help='Only include messages in given base path')
    (options, args) = p.parse_args()

    if args:
        dest = args[0]
    else:
        dest = '~/.cache/mutt_results'

    # Use expanduser() so that os.symlink() won't get weirded out by tildes.
    main(os.path.expanduser(dest).rstrip('/'), options)
