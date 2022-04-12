#! /bin/sh

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

	# Some programs ignore secret key files if they have git's default 644 permissions
	chmod -f 600 ~/dotfiles/devKeys/*.rsa
	chmod -f 600 ~/dotfiles/devKeys/*.gpg.sec

	# Add and trust monalisa GPG key, for signing commits.
	if [ -f ~/dotfiles/devKeys/monalisa.gpg.sec ]; then
		gpg --import ~/dotfiles/devKeys/monalisa.gpg.sec

		gpg -k --with-colons octocat@github.com |
			grep '^fpr:' |
			cut -d: -f10 |
			sed -e 's/$/:6:/g' |
			gpg --import-ownertrust
	fi
fi
