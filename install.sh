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

# Stuff to do only on github/github
if [ -f /workspaces/github/README.md -a -d /workspaces/.codespaces/.persistedshare/dotfiles/testKeys ]; then
    # add and trust monalisa GPG key
    test -f /workspaces/github/README.md -a -r /workspaces/.codespaces/.persistedshare/dotfiles/testKeys/monalisa.gpg.sec &&
        gpg --import /workspaces/.codespaces/.persistedshare/dotfiles/testKeys/monalisa.gpg.sec &&
        echo 27A08E3AFB8CDD4C0D4FE226AD3B4A12FAD9D319:6: | gpg --import-ownertrust

    # SSH private key files will be ignored with git's default 644 permissions
    chmod 600 /workspaces/.codespaces/.persistedshare/dotfiles/testKeys/*.rsa
fi
