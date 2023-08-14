usage_error() {
  echo $1
  echo
  echo "<base_url> examples:"
  echo '  CODESPACE:    http://api.github.localhost/repos/{owner}/{repo}'
  echo '  GHE TEST ENV: https://api.darylcantrell-03d56231eb10a1a11.ghe-test.org/repos/{owner}/{repo}'
}

branch_get() {
  base_url=$1; shift
  auth_token=$1; shift
  branch_name=${1#"refs/heads/"}; shift

  if [ -z "$branch_name" ]; then
    usage_error "Usage: branch_get <base_url> <auth_token> <branch_name>"
    return 1
  fi

  curl \
    --request GET -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    $base_url"/branches/"$branch_name
}

ref_get() {
  base_url=$1; shift
  auth_token=$1; shift
  branch_name=${1#"refs/heads/"}; shift

  if [ -z "$branch_name" ]; then
    usage_error "Usage: ref_get <base_url> <auth_token> <branch_name>"
    return 1
  fi

  curl \
    --request GET -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    $base_url"/git/refs/heads/"$branch_name
}

ref_force() {
  base_url=$1; shift
  auth_token=$1; shift
  branch_name=${1#"refs/heads/"}; shift
  sha=$1; shift

  if [ -z "$sha" ]; then
    usage_error "Usage: ref_force <base_url> <auth_token> <branch_name> <commit_sha>"
    return 1
  fi

  curl \
    --request PATCH -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{ "sha": "'$sha'", "force": true }' \
    $base_url"/git/refs/heads/"$branch_name
}

ref_create() {
  base_url=$1; shift
  auth_token=$1; shift
  branch_name=${1#"refs/heads/"}; shift
  sha=$1; shift

  if [ -z "$sha" ]; then
    usage_error "Usage: ref_force <base_url> <auth_token> <branch_name> <commit_sha>"
    return 1
  fi

  curl \
    --request POST -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{ "sha": "'$sha'", "ref": "'refs/heads/$branch_name'" }' \
    $base_url"/git/refs"
}
