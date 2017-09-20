#! /usr/bin/env python3

import argparse
import os, os.path, sys, subprocess
import re
import configparser

CHOICES = {
    'zsh': {'zshrc': '~/.zshrc', 'zshenv': '~/.zshenv', 'zprofile': '~/.zprofile'},
    'tmux': {'tmux.conf': '~/.tmux.conf'},
    'git': {'gitconfig': '~/.gitconfig', 'gitignore': '~/.gitignore'},
    'font': {'fontconfig': '~/.config/fontconfig'},
    'Xres': {'Xresources': '~/.Xresources'},
    'ignore': {'ignore': '~/.ignore'},
}

DEFAULT = [
    'zsh',
    'tmux',
    'git',
    'ignore',
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
    filename = os.path.expanduser('~/.gitconfig.local')
    if not os.path.isfile(filename):
        open(filename, 'a').close()
    gitconfig = configparser.ConfigParser()
    gitconfig.read(filename)
    name = None
    email = None
    if 'user' in gitconfig:
        if 'name' in gitconfig['user']:
            name = gitconfig['user']['name']
        if 'email' in gitconfig['user']:
            email = gitconfig['user']['email']
    else:
        gitconfig['user'] = {}
    tn = input('Enter your name{}: '.format('({})'.format(name) if name else ''))
    te = input('Enter your email{}: '.format('({})'.format(email) if email else ''))
    if tn:
        name = tn
    if te:
        email = te
    gitconfig['user']['name'] = name
    gitconfig['user']['email'] = email
    with open(filename, 'w') as file:
        gitconfig.write(file)

def tmux_hook():
    dirpath = os.path.expanduser('~/.tmux/plugins/tpm')
    if not os.path.isdir(dirpath):
        print('installing tmux plugin manager...')
        subprocess.call(['git clone --depth=1'
                         ' https://github.com/tmux-plugins/tpm'
                         ' ~/.tmux/plugins/tpm'
                         ' 2> /dev/null'], shell=True)
        install_script = os.path.join(dirpath, 'scripts/install_plugins.sh')
        subprocess.call([install_script], shell=True)

if __name__ == '__main__':
    args = parser.parse_args()

    deployer = ConfigDeployer(CHOICES, args.method, args.keep)
    deployer.set_hook('git', git_hook)
    deployer.set_hook('tmux', tmux_hook)

    if args.is_all:
        targets = list(CHOICES.keys())
    else:
        targets = args.targets
        if not targets:
            targets = DEFAULT

    deployer.deploy(targets)
