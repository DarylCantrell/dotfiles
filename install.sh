#! /bin/sh

# .bashrc
test -f /workspaces/.codespaces/.persistedshare/dotfiles/.bashrc &&
    echo >> ~/.bashrc &&
    echo source /workspaces/.codespaces/.persistedshare/dotfiles/.bashrc >> ~/.bashrc

# .bash_aliases
test -f /workspaces/.codespaces/.persistedshare/dotfiles/.bash_aliases &&
    echo >> ~/.bash_aliases &&
    echo source /workspaces/.codespaces/.persistedshare/dotfiles/.bash_aliases >> ~/.bash_aliases

# .dircolors (overwrite)
test -f /workspaces/.codespaces/.persistedshare/dotfiles/.dircolors &&
    ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.dircolors ~/.dircolors

