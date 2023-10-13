#! /bin/bash

# Link from homedir to dotfiles repo
test -d /workspaces/.codespaces/.persistedshare/dotfiles &&
  ln -s /workspaces/.codespaces/.persistedshare/dotfiles ~/dotfiles

# Execute dotfiles/.bashrc at end of .bashrc
test -f ~/dotfiles/.bashrc &&
  echo -e '\nsource ~/dotfiles/.bashrc' >> ~/.bashrc

# .bash_aliases
test -f ~/dotfiles/.bash_aliases &&
  echo -e '\nsource ~/dotfiles/.bash_aliases' >> ~/.bash_aliases

# .dircolors (overwrite)
test -f ~/dotfiles/.dircolors &&
  ln -sf ~/dotfiles/.dircolors ~/.dircolors

# Stuff to do only on github/github
if [ -f /workspaces/github/README.md ]; then

  git config --file /workspaces/github/.git/config --unset-all remote.origin.fetch
  git config --file /workspaces/github/.git/config remote.origin.fetch \
    "+refs/heads/master:refs/remotes/origin/master"
  # git config --file /workspaces/github/.git/config --add remote.origin.fetch \
  #   "+refs/heads/darylcantrell/*:refs/remotes/origin/darylcantrell/*"

  # Speed up global search in VS Code by ignoring some files which are not ignored by git
  if [ -f ~/dotfiles/.rgignore ]; then
    cp ~/dotfiles/.rgignore /workspaces/github
    (cd /workspaces/github && git update-index --assume-unchanged .rgignore)
  fi

  # Some programs ignore secret key files if they have default 644 permissions
  chmod -f 600 ~/dotfiles/devKeys/*.rsa
  chmod -f 600 ~/dotfiles/devKeys/*.ed25519
  chmod -f 600 ~/dotfiles/devKeys/*.gpg.sec

  # Git doesn't seem to like the default GPG
  git config --global --add gpg.program gpg2

  # Add and trust monalisa GPG key, for signing commits.
  if [ -f ~/dotfiles/devKeys/monalisa.gpg.sec ]; then
    gpg2 --import ~/dotfiles/devKeys/monalisa.gpg.sec

    gpg2 -k --with-colons octocat@github.com |
      grep '^fpr:' |
      cut -d: -f10 |
      sed -e 's/$/:6:/g' |
      gpg --import-ownertrust
  fi

  # Add and trust collaborator GPG key, for signing commits.
  if [ -f ~/dotfiles/devKeys/collaborator.gpg.sec ]; then
    gpg2 --import ~/dotfiles/devKeys/collaborator.gpg.sec

    gpg2 -k --with-colons collaborator@github.com |
      grep '^fpr:' |
      cut -d: -f10 |
      sed -e 's/$/:6:/g' |
      gpg --import-ownertrust
  fi

  # Add and verify dev server's GPG key, used by server to sign web edits, merges, etc.
  if [ -f ~/dotfiles/devKeys/devServerKey.gpg.pub ]; then
    gpg2 --import ~/dotfiles/devKeys/devServerKey.gpg.pub
    echo 'y' | gpg2 --command-fd 0 --sign-key --local-user AD3B4A12FAD9D319 08A088ACEF151AF6
  fi

  # Add dev server's SSH key to known hosts
  if [ \! -f ~/.ssh/known_hosts ]; then
    echo >> ~/.ssh/known_hosts '|1|Xe11EuW9c8eB6y7z+aY86v8M+Iw=|GVy5Jejcih/Wq+QJW/EPN/MHbWw= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSzhHAZZiodxcTA6G6Satu+KIfatmx0ABMyKKcVmPatsPnT30IMDs0QQuufMGuZ1mwuz1Ziy+NWD/rUk2f3c8l9LRxXVTcwUBfXLEBQpLDbeFSN/tp6VrSs0AnfCZMBiI+V9Uak6sh5FN9hsADDMZz8JcXLdxfxgqBU6Ib+VzrBK/aSIoSaKLZM8FQI+z2TR/64sDYM7uHdbzz9y2PEOyz/LUcnKAkM/ye8S1omXpMcCnJIOC2DZMWp0z6WiEOgQewYokwi3f5rv3EYP4YpV7ks1C8fLRMk2a1ixwrCNWwqqWYQadwbfyomVCWGJlwOFY7PLpCHtg+yzSp3FAaaGtH4QTrvT/zKQ8msneDM/fVqqOq9ot8DPZWYLtV+nBDnS5TE4FODZopx5+5RPA7dDuvlCtqOcOhF1b3W8t1rhzMmTj3qCC6r/e9G9lClog5lEWDsGBn4hJBeax61XHmZQl/lu4gdnhQw3RHB9oQlxD6QPOtBaJKdgZSaWgn16l3z/0='
  fi

  cat >> /etc/hosts <<-EOF
    127.0.0.1  github.localhost
    127.0.0.1  api.github.localhost
  EOF

  # credential.helper config in github dev container doesn't work with dotFiles repo
  test -f ~/dotfiles/.git/config &&
    git config -f ~/dotfiles/.git/config 'credential.helper' ''

  # git config -f /workspaces/authzd/.git/config 'credential.helper' ''
fi
