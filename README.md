# dotfiles of pika

My personal dotfiles.

## How to deploy
```
$ ./deploy.py -h
```

## Zsh

Need zsh 5.2+

using [zplug](https://github.com/b4b4r07/zplug).

### prompt theme:
[pika-prompt](https://github.com/leomao/pika-prompt)

### plugins:

- [zsh-hooks](https://github.com/leomao/zsh-hooks)
- [zsh-async](https://github.com/mafredri/zsh-async)
- [vim.zsh](https://github.com/leomao/vim.zsh)
- [zsh-completions](https://github.com/zsh-users/zsh-completions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [z](https://github.com/rupa/z)
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
- [zsh-manydots-magic](https://github.com/knu/zsh-manydots-magic)

### Customization

Put your customization in `.zshenv.local` and `.zshrc.local`.

## Tmux

Since tmux 2.1 has some backward imcompatible changes, the configuration
only works with tmux 2.1 and above.

## Git

One can add custom settings in `~/.gitconfig.local`.
Notice that this configuration use [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
as the pager of `git diff` and `git show`. If you don't want to use the
zsh config, you should overwrite this settings in `~/.gitconfig.local`.

## Fontconfig

This fontconfig is for Traditional Chinese users on Archlinux primarily.
It's not tested on other distros. But it should work on other distros as well
so long as you have the following:

- one of "Source Han Sans TW", "Source Han Sans TC", "Noto Sans CJK TC"
- "Source Code Pro" or "Inconsolata"

For Archlinux users, you can just install required fonts by
```
# pacman -S adobe-source-code-pro-fonts adobe-source-han-sans-tw-fonts
```
