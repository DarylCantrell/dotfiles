status_post() {
  local base_url=`git config --local --get ghapi.url`
  [ -z "$base_url" ] && echo "Error: ghapi.url not set" && return 1
  local auth_token=`git config --local --get ghapi.token`
  [ -z "$auth_token" ] && echo "Error: ghapi.token not set" && return 1

  local context=$1; shift
  [ -z "$context" ] && echo "Usage: status_approve <context> <commit_id> <state>" && return 1
  local commit_id=$1; shift
  [ -z "$commit_id" ] && echo "Usage: status_approve <context> <commit_id> <state>" && return 1
  if [ ${#commit_id} -lt 40 ]; then
    commit_id=`git rev-parse $commit_id`
  fi
  local state=$1; shift
  [ -z "$state" ] && echo "Usage: status_approve <context> <commit_id> <state>" && return 1

  # Add --fail-with-body after bug fixed
  curl \
    --request POST \
    --silent \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{
        "state":"'$state'",
        "target_url":"https://example.com/build/status",
        "description":"Status '$context'",
        "context":"'$context'"
    }' \
    "$base_url/statuses/$commit_id"
}

status_success() {
  local context=$1; shift
  [ -z "$context" ] && echo "Usage: status_success <context> <commit_id>" && return 1
  local commit_id=$1; shift
  [ -z "$commit_id" ] && echo "Usage: status_success <context> <commit_id>" && return 1

  status_post $context $commit_id success
}

status_failure() {
  local context=$1; shift
  [ -z "$context" ] && echo "Usage: status_failure <context> <commit_id>" && return 1
  local commit_id=$1; shift
  [ -z "$commit_id" ] && echo "Usage: status_failure <context> <commit_id>" && return 1

  status_post $context $commit_id failure
}
