check_post() {
  local base_url=`git config --local --get ghapi.url`
  [ -z "$base_url" ] && echo "Error: ghapi.url not set" && return 1
  local auth_token=`git config --local --get ghapi.token`
  [ -z "$auth_token" ] && echo "Error: ghapi.token not set" && return 1

  local context=$1; shift
  [ -z "$context" ] && echo "Usage: check_post <context> <commit_id> <state>" && return 1
  local commit_id=$1; shift
  [ -z "$commit_id" ] && echo "Usage: check_post <context> <commit_id> <state>" && return 1
  if [ ${#commit_id} -lt 40 ]; then
    commit_id=`git rev-parse $commit_id`
  fi
  local state=$1; shift
  [ -z "$state" ] && echo "Usage: check_post <context> <commit_id> <state>" && return 1

  local status_and_conclusion=
  case $state in
  queued|in_progress)
    status_and_conclusion='"status": "'$state'"'
    ;;
  *)
    status_and_conclusion='"status": "'completed'", "conclusion": "'$state'",'
    ;;
  esac

  # Add --fail-with-body after bug in curl 7.68 is fixed
  curl \
    --request POST \
    --silent \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{
      "name": "'$context'",
      "head_sha": "'$commit_id'",
      '"$status_and_conclusion"'
      "details_url": "https://example.com/check/status",
      "output": {
        "title": "Check '$context'",
        "summary":""
      }
    }' \
    "$base_url/check-runs"
}

check_success() {
  local context=$1; shift
  [ -z "$context" ] && echo "Usage: check_success <context> <commit_id>" && return 1
  local commit_id=$1; shift
  [ -z "$commit_id" ] && echo "Usage: check_success <context> <commit_id>" && return 1

  check_post $context $commit_id success
}

check_failure() {
  local context=$1; shift
  [ -z "$context" ] && echo "Usage: status_failure <context> <commit_id>" && return 1
  local commit_id=$1; shift
  [ -z "$commit_id" ] && echo "Usage: status_failure <context> <commit_id>" && return 1

  check_post $context $commit_id failure
}
