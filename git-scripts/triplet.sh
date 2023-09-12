#! /bin/bash

single() {
  n=$1; shift;
    if [ -z "$n" ]; then
    return 1
  fi
  local url=http://api.github.localhost/repos/github/public-server
  local mona_pat=`cat /workspaces/mona.pat`

  git checkout main
  git pull

  pushnewbranch topic$n
  local pr=`pr_create $url $mona_pat topic$n main`

  pr_id=`sed '/\r$/d' <<< "$pr" | jq -r .id`
  pr_approve $url `cat /workspaces/collab.pat` $pr_id
}

triplet() {
  n=$1; shift;
    if [ -z "$n" ]; then
    return 1
  fi
  local url=http://api.github.localhost/repos/github/public-server
  local mona_pat=`cat /workspaces/mona.pat`

  git checkout main
  git pull

  pushnewbranch topic$n"a"
  git checkout topic$n"a"
  pushnewbranch topic$n"b"
  force topic$n"c" topic$n"b"
  git push origin topic$n"c"

  git checkout main

  pr_create $url $mona_pat topic$n"a" main
  local pr_b=`pr_create $url $mona_pat topic$n"b" main`
  pr_create $url $mona_pat topic$n"c" main

  pr_b_id=`sed '/\r$/d' <<< "$pr_b" | jq -r .id`
  pr_approve $url `cat /workspaces/collab.pat` $pr_b_id
}
