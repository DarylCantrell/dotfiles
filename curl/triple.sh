triple() {
  local usage="Usage: triple <source_prefix>"
  local source_prefix=$1; shift
  [ -z "$source_prefix" ] && echo $usage && return 1

  pushd /workspaces/mona-public-server

  local pr_create_out=`pr_create ${source_prefix}-a`
  local res=$?
  if [ $res -ne 0 ]; then
    return $res
  fi
  local pr_a_id=`sed -n '$p' <<< $pr_create_out`
  status_success foo ${source_prefix}-a

  cd /workspaces/collab-public-server

  pr_approve $pr_a_id

  pr_create_out=`pr_create ${source_prefix}-b`
  res=$?
  if [ $res -ne 0 ]; then
    return $res
  fi
  local pr_b_id=`sed -n '$p' <<< $pr_create_out`
  status_success foo ${source_prefix}-b

  cd /workspaces/outsider-public-server

  pr_approve $pr_b_id

  local pr_create_out=`pr_create ${source_prefix}-c`
  local res=$?
  if [ $res -ne 0 ]; then
    return $res
  fi
  local pr_c_id=`sed -n '$p' <<< $pr_create_out`
  status_success foo ${source_prefix}-c

  cd /workspaces/mona-public-server

  pr_approve $pr_c_id

  popd
}

q_stat() {
  sudo /usr/bin/mysql -B -D github_development_collab -e "select concat('status_success foo ', head_sha, ' # PR ', pull_request_id) as '' from merge_queue_entries"
  echo
}