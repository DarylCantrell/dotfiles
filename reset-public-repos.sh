#! /bin/bash

pushd /workspaces

# Clone public-server as monalisa

rm -rf /workspaces/public-server
mkdir /workspaces/public-server
cd /workspaces/public-server

GIT_SSH_COMMAND="ssh -i $(realpath ~/dotfiles/devKeys/monalisa.rsa)" \
	git clone ssh://git@localhost:3035/github/public-server.git .

git config --local --add core.sshcommand "ssh -i $(realpath ~/dotfiles/devKeys/monalisa.rsa)"

# Clone public-server as collaborator

rm -rf /workspaces/collab-public-server
mkdir /workspaces/collab-public-server
cd /workspaces/collab-public-server

GIT_SSH_COMMAND="ssh -i $(realpath ~/dotfiles/devKeys/collaborator.rsa)" \
	git clone ssh://git@localhost:3035/github/public-server.git .

git config --local --add core.sshcommand "ssh -i $(realpath ~/dotfiles/devKeys/collaborator.rsa)"

popd
