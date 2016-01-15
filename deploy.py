#! /usr/bin/env python3

import argparse
import os, os.path, sys, subprocess
import re

CHOICES = {
    'zsh': {'.zshrc': '~/.zshrc', '.zshenv': '~/.zshenv'},
    'tmux': {'.tmux.conf': '~/.tmux.conf'},
    'git': {'.gitconfig': '~/.gitconfig', '.gitignore': '~/.gitignore'},
    'font': {'fontconfig': '~/.config/fontconfig'},
    'Xres': {'.Xresources': '~/.Xresources'},
}

DEFAULT = [
    'zsh',
    'tmux',
    'git',
]

FILE_PATH = os.path.dirname(os.path.realpath(__file__))
CMD_LN = 'ln -srfT {} {}'
if sys.platform == 'darwin':
    CMD_LN = 'ln -sf {} {}'

parser = argparse.ArgumentParser(description='Deploy config files.',
                                 formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('-k', '--keep', action='store_true',
                    help='keep old files.')
parser.add_argument('-a', '--all', dest='is_all', action='store_true',
                    help='deploy all available targets.')
parser.add_argument('-l', '--link', dest='method', action='store_const',
                    const='LINK', default='COPY',
                    help='use symlink if possible.')
parser.add_argument('targets', nargs='*',
                    help='deploy target(s).\nchoices: {}\n'
                    '(default is {})'.format(','.join(CHOICES.keys()),
                                              ','.join(DEFAULT)))

class ConfigDeployer:
    METHODS = ['COPY', 'LINK']

    def __init__(self, choices, method, keep):
        self.keep = keep
        self.choices = choices
        self.hooks = {k: None for k in choices.keys()}
        self.methods = {k: method for k in choices.keys()}

    def set_hook(self, target, hook):
        if target not in self.choices:
            print('ERR: {} is not in the choices.'.format(target))
            return
        self.hooks[target] = hook

    def set_method(self, target, method):
        if method not in ConfigDeployer.METHODS:
            print('ERR: {} is not an available methods.'.format(target))
            return
        self.methods[target] = method

    def run_cmd(self, cmd):
        subprocess.call([cmd], shell=True)

    def check_path(self, dests):
        if self.keep:
            cmd = 'mv {0} {0}.old'
        else:
            cmd = 'rm -rf {0}'
        for d in dests:
            if os.path.exists(os.path.expanduser(d)):
                self.run_cmd(cmd.format(d))

    def deploy(self, targets):
        for target in targets:
            if target not in self.choices:
                print('{} is not a valid target, skip.'.format(target))
                continue

            print('deploying {}...'.format(target))
            if self.methods[target] == 'LINK':
                cmd = CMD_LN
            elif self.methods[target] == 'COPY':
                cmd = 'cp -rf {} {}'
            dests = list(self.choices[target].values())
            self.check_path(dests)

            for f, t in self.choices[target].items():
                f = os.path.join(FILE_PATH, f)
                self.run_cmd(cmd.format(f, t))

            if self.hooks[target]:
                self.hooks[target]()

        print('done.')

def git_hook():
    name = input('Enter your name: ')
    email = input('Enter your email: ')
    filename = os.path.expanduser('~/.gitconfig')
    with open(filename) as file:
        content = file.read()
    content = re.sub(r'<YourName>', name, content)
    content = re.sub(r'<YourEmail>', email, content)
    with open(filename, 'w') as file:
        file.write(content)


if __name__ == '__main__':
    args = parser.parse_args()

    deployer = ConfigDeployer(CHOICES, args.method, args.keep)
    deployer.set_method('git', 'COPY')
    deployer.set_hook('git', git_hook)

    if args.is_all:
        targets = list(CHOICES.keys())
    else:
        targets = args.targets
        if not targets:
            targets = DEFAULT

    deployer.deploy(targets)
