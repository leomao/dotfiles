# dotfiles of pika

My personal dotfiles.
These dotfiles are only tested on Archlinux with lastest software.

## How to deploy
```
$ ./deploy.py -h
```

## Zsh

Need zsh 5.2+.

using [zplug](https://github.com/b4b4r07/zplug).

### prompt theme:
[pika-prompt](https://github.com/leomao/pika-prompt)

### plugins:

- [zsh-hooks](https://github.com/leomao/zsh-hooks)
- [zsh-async](https://github.com/mafredri/zsh-async)
- [vim.zsh](https://github.com/leomao/vim.zsh)
- [zsh-completions](https://github.com/zsh-users/zsh-completions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [enhancd](https://github.com/b4b4r07/enhancd)
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)

### Related tools

- [ag](https://github.com/ggreer/the_silver_searcher)
- [exa](https://github.com/ogham/exa)

### Customization

Put your customization in `~/.zshenv.local` and `~/.zshrc.local`.

## Tmux

Need tmux 2.2+.

tmux plugins managed by [tpm](https://github.com/tmux-plugins/tpm):
- [tpm](https://github.com/tmux-plugins/tpm)
- [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank)
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)

## Git

One can add custom settings in `~/.gitconfig.local`.
Notice that this configuration use [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
as the pager of `git diff` and `git show`. If you don't want to use the
zsh config, you should overwrite this setting in `~/.gitconfig.local`.

## Fontconfig

This fontconfig is for Traditional Chinese users on Archlinux primarily.
It's not tested on other distros. But it should work on other distros as well
so long as you have the following:

- one of "Noto Sans CJK TC", "Source Han Sans TW", "Source Han Sans TC"
- "Source Code Pro" or "Inconsolata"

For Archlinux users, you can just install required fonts by
```console
# pacman -S noto-fonts-cjk adobe-source-code-pro-fonts
```
