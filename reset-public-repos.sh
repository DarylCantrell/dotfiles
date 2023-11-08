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

  git config --local --add ghapi.url http://api.github.localhost/repos/github/public-server
  if [ -f /workspaces/pat.$name ]; then
    git config --local --add ghapi.token `cat /workspaces/pat.$name`
  fi
}

create_pat_file() {
  local login=$1; shift
  local name=$1; shift
  local site_admin=$1; shift

  if [ ! -f /workspaces/pat.$name ]; then
    ./bin/rails console <<EOF | grep -Eo 'ghp_[^"]+' > /workspaces/pat.$name
    current_user=User.find_by_login('${login}')

    normalized_scopes = ['admin:enterprise', 'admin:gpg_key', 'admin:org', 'admin:org_hook', 'admin:public_key', 'admin:repo_hook',
      'admin:ssh_signing_key', 'audit_log', 'codespace', 'copilot', 'delete:packages', 'delete_repo', 'gist', 'notifications',
      'project', 'repo', 'user', 'workflow', 'write:discussion', 'write:packages'${site_admin}]

    access = current_user.oauth_accesses.build do |a|
      a.application_id = OauthApplication::PERSONAL_TOKENS_APPLICATION_ID
      a.application_type = OauthApplication::PERSONAL_TOKENS_APPLICATION_TYPE
      a.description = 'pat1'
      a.scopes = normalized_scopes
    end
    access.set_expiration(30, 30)
    token = access.set_random_token_pair

    last_operations = DatabaseSelector::LastOperations.from_token(token)
    access.save
    last_operations.store_latest_writes
EOF
  fi
}

pushd /workspaces/github

create_pat_file monalisa     mona   ", 'site_admin'"
create_pat_file collaborator collab ""
create_pat_file outsider outsider   ""

clone_repo monalisa     mona     octocat
clone_repo collaborator collab   collaborator
clone_repo outsider     outsider outsider

popd
