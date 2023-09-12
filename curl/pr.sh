usage_error() {
  echo $1
  echo
  echo "<base_url> examples:"
  echo '  CODESPACE:    http://api.github.localhost/repos/{owner}/{repo}'
  echo '  GHE TEST ENV: https://api.darylcantrell-03d56231eb10a1a11.ghe-test.org/repos/{owner}/{repo}'
}

pr_create() {
  local base_url=$1; shift
  local auth_token=$1; shift
  local source_branch=$1; shift
  local target_branch=$1; shift

  if [ -z "$target_branch" ]; then
    usage_error "Usage: pr_create <base_url> <auth_token> <source_branch> <target_branch>"
    return 1
  fi

  curl \
    --request POST -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{
      "title":"PR '$source_branch' -> '$target_branch'",
      "body":"A pull request",
      "base":"'$target_branch'",
      "head":"'$source_branch'"
    }' \
    $base_url"/pulls"
}

pr_close() {
  base_url=$1; shift
  auth_token=$1; shift
  pr_number=$1; shift

  if [ -z "$pr_number" ]; then
    usage_error "Usage: pr_close <base_url> <auth_token> <pr_number>"
    return 1
  fi

  curl \
    --request PATCH -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{ "state":"closed" }' \
    $base_url"/pulls/"$pr_number
}

pr_approve() {
  base_url=$1; shift
  auth_token=$1; shift
  pr_number=$1; shift

  if [ -z "$pr_number" ]; then
    usage_error "Usage: pr_approve <base_url> <auth_token> <pr_number>"
    return 1
  fi

  curl \
    --request POST -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{ "event":"APPROVE" }' \
    $base_url"/pulls/"$pr_number"/reviews"
}

pr_merge() {
  base_url=$1; shift
  auth_token=$1; shift
  pr_number=$1; shift
  sha=$1; shift
  merge_method=$1; shift

  if [ -z "$sha" ]; then
    usage_error "Usage: pr_merge <base_url> <auth_token> <pr_number> <sha> [<merge_method>]"
    return 1
  fi

  curl \
    --request PUT -i \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{
      "sha": "'$sha'",
      "merge_method": "'${merge_method:-"merge"}'"
    }' \
    $base_url"/pulls/"$pr_number"/merge"
}
