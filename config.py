#! /usr/bin/env python

import argparse
import os, os.path, sys, subprocess
import re

parser = argparse.ArgumentParser(description='Deploy config files.')
parser.add_argument('-k', '--keep', action='store_true', help='keep old files')
parser.add_argument('target', nargs='?', default='all',
                    choices=['all', 'git', 'zsh', 'font', 'tmux'],
                    help='deploy target (default is all)')

def run_cmd(cmd):
    subprocess.call([cmd], shell=True)

def check_path(targets, keep):
    if keep:
        cmd = 'mv {0} {0}.old'
    else:
        cmd = 'rm -rf {0}'
    for t in targets:
        if os.path.exists(os.path.expanduser(t)):
            run_cmd(cmd.format(t))

def task_link(maps, keep):
    targets = list(maps.values())
    check_path(targets, keep)

    for f, t in maps.items():
        run_cmd('ln -srfT {} {}'.format(f, t))

def task_copy(maps, keep):
    targets = list(maps.values())
    check_path(targets, keep)

    for f, t in maps.items():
        run_cmd('cp {} {}'.format(f, t))

def task_git(keep):
    gitmap = {'.gitconfig': '~/.gitconfig'}
    task_copy(gitmap, keep)

    name = input('Enter your name: ')
    email = input('Enter your email: ')
    filename = os.path.expanduser('~/.gitconfig')
    with open(filename) as file:
        content = file.read()
    content = re.sub(r'<YourName>', name, content)
    content = re.sub(r'<YourEmail>', email, content)
    with open(filename, 'w') as file:
        file.write(content)

def task_zsh(keep):
    zshmap = {
        '.zshrc': '~/.zshrc',
    }
    task_link(zshmap, keep)

def task_font(keep):
    fontmap = {'fontconfig': '~/.config/fontconfig'}
    task_link(fontmap, keep)

def task_tmux(keep):
    tmuxmap = {'.tmux.conf': '~/.tmux.conf'}
    task_link(tmuxmap, keep)


if __name__ == '__main__':
    args = parser.parse_args()
    if args.target == "all":
        task_zsh(args.keep)
        task_font(args.keep)
        task_tmux(args.keep)
        task_git(args.keep)
    elif args.target == "git":
        task_git(args.keep)
    elif args.target == "zsh":
        task_zsh(args.keep)
    elif args.target == "font":
        task_font(args.keep)
    elif args.target == "tmux":
        task_tmux(args.keep)
    else:
        parser.print_help()
