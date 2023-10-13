pr_create() {
  local base_url=`git config --local --get ghapi.url`
  [ -z "$base_url" ] && echo "Error: ghapi.url not set" && return 1

  local auth_token=`git config --local --get ghapi.token`
  [ -z "$auth_token" ] && echo "Error: ghapi.token not set" && return 1

  local source_branch=${1#"refs/heads/"}; shift
  [ -z "$source_branch" ] && echo "Usage: pr_create <source_branch> [<target_branch>]" && return 1

  local target_branch=${1#"refs/heads/"}; shift
  [ -z "$target_branch" ] && target_branch=main

  if git show-ref --quiet refs/heads/$source_branch
  then :
  else
    pushnewbranch $source_branch || return 1
  fi

  local curl_output=
  curl_output=`curl \
    --request POST -s \
    --fail-with-body \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{
      "title":"PR '$source_branch' -> '$target_branch'",
      "body":"A pull request",
      "base":"'$target_branch'",
      "head":"'$source_branch'"
    }' \
    $base_url"/pulls"`
  local res=$?

  if [ $res -ne 0 ]; then
    echo
    jq -r .message <<< "$curl_output"
    jq -r '.errors[] | .message' <<< "$curl_output"
    return $res
  else
    echo -e '\nNew PR:'
    jq -r .html_url <<< "$curl_output"
  fi
}

# pr_close() {
#   base_url=$1; shift
#   auth_token=$1; shift
#   pr_number=$1; shift

#   if [ -z "$pr_number" ]; then
#     usage_error "Usage: pr_close <base_url> <auth_token> <pr_number>"
#     return 1
#   fi

#   curl \
#     --request PATCH -i \
#     --header "Content-Type: application/json" \
#     --header "Accept: application/vnd.github+json" \
#     --header "Authorization: token $auth_token" \
#     --data '{ "state":"closed" }' \
#     $base_url"/pulls/"$pr_number
# }

# pr_approve() {
#   base_url=$1; shift
#   auth_token=$1; shift
#   pr_number=$1; shift

#   if [ -z "$pr_number" ]; then
#     usage_error "Usage: pr_approve <base_url> <auth_token> <pr_number>"
#     return 1
#   fi

#   curl \
#     --request POST -i \
#     --header "Content-Type: application/json" \
#     --header "Accept: application/vnd.github+json" \
#     --header "Authorization: token $auth_token" \
#     --data '{ "event":"APPROVE" }' \
#     $base_url"/pulls/"$pr_number"/reviews"
# }

# pr_merge() {
#   base_url=$1; shift
#   auth_token=$1; shift
#   pr_number=$1; shift
#   sha=$1; shift
#   merge_method=$1; shift

#   if [ -z "$sha" ]; then
#     usage_error "Usage: pr_merge <base_url> <auth_token> <pr_number> <sha> [<merge_method>]"
#     return 1
#   fi

#   curl \
#     --request PUT -i \
#     --header "Content-Type: application/json" \
#     --header "Accept: application/vnd.github+json" \
#     --header "Authorization: token $auth_token" \
#     --data '{
#       "sha": "'$sha'",
#       "merge_method": "'${merge_method:-"merge"}'"
#     }' \
#     $base_url"/pulls/"$pr_number"/merge"
# }
