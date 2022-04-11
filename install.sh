#! /bin/sh

test -d /workspaces/.codespaces/.persistedshare/dotfiles &&
    ln -s /workspaces/.codespaces/.persistedshare/dotfiles ~/dotfiles

# Execute dotfiles/.bashrc at end of .bashrc
test -f /workspaces/.codespaces/.persistedshare/dotfiles/.bashrc &&
    echo -e '\nsource /workspaces/.codespaces/.persistedshare/dotfiles/.bashrc' >> ~/.bashrc

# .bash_aliases
test -f /workspaces/.codespaces/.persistedshare/dotfiles/.bash_aliases &&
    echo -e '\nsource /workspaces/.codespaces/.persistedshare/dotfiles/.bash_aliases' >> ~/.bash_aliases

# .dircolors (overwrite)
test -f /workspaces/.codespaces/.persistedshare/dotfiles/.dircolors &&
    ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.dircolors ~/.dircolors

# Stuff to do only on github/github
if [ -f /workspaces/github/README.md -a -d /workspaces/.codespaces/.persistedshare/dotfiles/devKeys ]; then

    # Add and trust monalisa GPG key
    test -f /workspaces/github/README.md -a -r /workspaces/.codespaces/.persistedshare/dotfiles/devKeys/monalisa.gpg.sec &&
        gpg --import /workspaces/.codespaces/.persistedshare/dotfiles/devKeys/monalisa.gpg.sec &&
        echo 27A08E3AFB8CDD4C0D4FE226AD3B4A12FAD9D319:6: | gpg --import-ownertrust

    # Some private key files will be ignored if they have git's default 644 permissions
    chmod 600 /workspaces/.codespaces/.persistedshare/dotfiles/devKeys/*.rsa \
        /workspaces/.codespaces/.persistedshare/dotfiles/devKeys/*.gpg.sec
fi
