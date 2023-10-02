#! /bin/bash

# This blows away your local changes (if any), and makes new clones of public-server for monalisa, collaborator, and outsider.
# You will want to run `add_ssh_keys.sh`` first.

pushd /workspaces

# Clone public-server as monalisa

rm -rf /workspaces/mona-public-server
mkdir /workspaces/mona-public-server
cd /workspaces/mona-public-server

GIT_SSH_COMMAND="ssh -i $(realpath ~/dotfiles/devKeys/monalisa.ed25519)" \
	git clone ssh://git@localhost:3035/github/public-server.git .

git config --local --add core.sshcommand "ssh -i $(realpath ~/dotfiles/devKeys/monalisa.ed25519)"
git config --local --add gpg.ssh.allowedSignersFile "$(realpath ~/dotfiles/devKeys/allowed_signers)"

git config --local --unset user.name
git config --local --add user.name monalisa

git config --local --unset user.email
git config --local --add user.email octocat@github.com

# Clone public-server as collaborator

rm -rf /workspaces/collab-public-server
mkdir /workspaces/collab-public-server
cd /workspaces/collab-public-server

GIT_SSH_COMMAND="ssh -i $(realpath ~/dotfiles/devKeys/collaborator.ed25519)" \
	git clone ssh://git@localhost:3035/github/public-server.git .

git config --local --add core.sshcommand "ssh -i $(realpath ~/dotfiles/devKeys/collaborator.ed25519)"
git config --local --add gpg.ssh.allowedSignersFile "$(realpath ~/dotfiles/devKeys/allowed_signers)"

git config --local --unset user.name
git config --local --add user.name collaborator

git config --local --unset user.email
git config --local --add user.email collaborator@github.com

# Clone public-server as outsider

rm -rf /workspaces/outsider-public-server
mkdir /workspaces/outsider-public-server
cd /workspaces/outsider-public-server

GIT_SSH_COMMAND="ssh -i $(realpath ~/dotfiles/devKeys/outsider.ed25519)" \
	git clone ssh://git@localhost:3035/github/public-server.git .

git config --local --add core.sshcommand "ssh -i $(realpath ~/dotfiles/devKeys/outsider.ed25519)"
git config --local --add gpg.ssh.allowedSignersFile "$(realpath ~/dotfiles/devKeys/allowed_signers)"

git config --local --unset user.name
git config --local --add user.name outsider

git config --local --unset user.email
git config --local --add user.email outsider@github.com

popd
