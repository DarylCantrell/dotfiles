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
    --request POST \
    -s --fail-with-body \
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

pr_create_multi() {
  local usage="Usage: pr_create_multi <source_branch> <count> [<target_branch>]"
  local source_branch=$1; shift
  [ -z "$source_branch" ] && echo $usage && return 1
  local count=$1; shift
  [ -z "$count" ] && echo $usage && return 1

  local target_branch=$1; shift

  for ((i=$count; i>=1; i--)); do
    pr_create $source_branch"-"$i $target_branch
  done
}

pr_approve() {
  local base_url=`git config --local --get ghapi.url`
  [ -z "$base_url" ] && echo "Error: ghapi.url not set" && return 1
  local auth_token=`git config --local --get ghapi.token`
  [ -z "$auth_token" ] && echo "Error: ghapi.token not set" && return 1

  local pr_number=$1; shift
  [ -z "$pr_number" ] && echo "Usage: pr_approve <pr_number>" && return 1

  curl \
    --request POST \
    -s --fail-with-body \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{ "event":"APPROVE" }' \
    $base_url"/pulls/"$pr_number"/reviews"
}

pr_approve_multi() {
  local usage="Usage: pr_approve_multi <count> <pr_number>"
  local count=$1; shift
  [ -z "$count" ] && echo $usage && return 1
  local pr_number=$1; shift
  [ -z "$pr_number" ] && echo $usage && return 1

  for ((i=$pr_number; i<$pr_number+$count; i++)); do
    pr_approve $i
  done
}

pr_merge() {
  local base_url=`git config --local --get ghapi.url`
  [ -z "$base_url" ] && echo "Error: ghapi.url not set" && return 1
  local auth_token=`git config --local --get ghapi.token`
  [ -z "$auth_token" ] && echo "Error: ghapi.token not set" && return 1

  pr_number=$1; shift
  [ -z "$pr_number" ] && echo "Usage: pr_approve <pr_number> [merge|rebase|squash]" && return 1
  merge_method=$1; shift

  local curl_output=
  curl_output=`curl \
    -s --fail-with-body \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    $base_url"/pulls/"$pr_number`
  local res=$?

  local head_sha=
  if [ $res -ne 0 ]; then
    echo
    jq -r .message <<< "$curl_output"
    jq -r '.errors[] | .message' <<< "$curl_output"
    return $res
  else
    head_sha=`jq -r .head.sha <<< "$curl_output"`
  fi

  curl \
    --request PUT \
    -s --fail-with-body \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: token $auth_token" \
    --data '{
      "sha": "'$head_sha'",
      "merge_method": "'${merge_method:-"merge"}'"
    }' \
    $base_url"/pulls/"$pr_number"/merge"
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
