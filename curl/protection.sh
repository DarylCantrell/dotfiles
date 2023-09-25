usage_error() {
  echo $1
  echo
  echo "<base_url> examples:"
  echo '  CODESPACE:    http://api.github.localhost/repos/{owner}/{repo}'
  echo '  GHE TEST ENV: https://api.darylcantrell-03d56231eb10a1a11.ghe-test.org/repos/{owner}/{repo}'
}

prot_get() {
  local base_url=$1; shift
  local auth_token=$1; shift
  local branch_name=${1#"refs/heads/"}; shift

  if [ -z "$branch_name" ]; then
    usage_error "Usage: prot_get <base_url> <auth_token> <branch_name>"
    return 1
  fi

  curl \
    --request GET -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    $base_url"/branches/"$branch_name"/protection"
}

prot_create() {
  local base_url=$1; shift
  local auth_token=$1; shift
  local branch_name=${1#"refs/heads/"}; shift

  if [ -z "$branch_name" ]; then
    usage_error "Usage: prot_create <base_url> <auth_token> <branch_name>"
    return 1
  fi

  curl \
    --request PUT -i -v \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{
      "required_status_checks": null,
      "required_pull_request_reviews": {
        "required_approving_review_count": 1
      },
      "restrictions": null,
      "enforce_admins": false,
    }' \
    $base_url"/branches/"$branch_name"/protection"
}
