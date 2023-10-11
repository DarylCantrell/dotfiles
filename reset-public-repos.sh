#! /bin/bash

# This blows away your local changes (if any), and makes new clones of public-server for monalisa, collaborator, and outsider.
# You will want to run `add_ssh_keys.sh` first.

clone_repo() {
  local login=$1; shift
  local name=$1; shift
  local email=$1; shift

  rm -rf /workspaces/${name}-public-server
  mkdir /workspaces/${name}-public-server
  cd /workspaces/${name}-public-server

  GIT_SSH_COMMAND="ssh -i $(realpath ~/dotfiles/devKeys/${login}.ed25519)" \
    git clone ssh://git@localhost:3035/github/public-server.git .

  git config --local --add core.sshcommand "ssh -i $(realpath ~/dotfiles/devKeys/${login}.ed25519)"

  git config --local --unset user.name
  git config --local --add user.name ${login}

  git config --local --unset user.email
  git config --local --add user.email ${email}@github.com

  git config --local gpg.format ssh
  git config --local user.signingkey "$(realpath ~/dotfiles/devKeys/${login}.ed25519)"
  git config --local --add gpg.ssh.allowedSignersFile "$(realpath ~/dotfiles/devKeys/allowed_signers)"
  git config --local commit.gpgsign true
}

pushd /workspaces

clone_repo monalisa     mona     octocat
clone_repo collaborator collab   collaborator
clone_repo outsider     outsider outsider

popd
