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

	# Speed up global search in VS Code by ignoring some files which are not ignored by git
	cp ~/dotfiles/.rgignore /workspaces/github
	echo /.rgignore >> /workspaces/github/.git/info/exclude

	# Some programs ignore secret key files if they have default 644 permissions
	chmod -f 600 ~/dotfiles/devKeys/*.rsa
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
		echo 'y' | gpg2 --command-fd 0 --sign-key 08A088ACEF151AF6
	fi

	cat >> /etc/hosts <<-EOF
		127.0.0.1	github.localhost
		127.0.0.1	api.github.localhost
	EOF

	# credential.helper config in github dev container doesn't work with dotFiles repo
	test -f ~/dotfiles/.git/config &&
		git config -f ~/dotfiles/.git/config 'credential.helper' ''

	# git config -f /workspaces/authzd/.git/config 'credential.helper' ''
fi
