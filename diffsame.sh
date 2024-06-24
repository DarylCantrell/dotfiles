#! /bin/bash

check_commits_exist() {
  for c in "$@"; do
    git cat-file -e "$c^{commit}" > /dev/null 2>&1 || { echo 1>&2 "Error: commit '$c' does not exist"; exit -1; }
    shift
  done
}

if [[ $# -ne 4 ]]; then
  echo 1>&2 "Usage: $0 <base_1> <head_1> <base_2> <head_2>"
  echo 1>&2 "       <base_1> is ancestor of <base_2>"
  exit -1
fi

rtn_value=0

base_1=$1; shift    # B
head_1=$1; shift    # H
base_2=$1; shift    # B'
head_2=$1; shift    # H'
check_commits_exist "$base_1" "$head_1" "$base_2" "$head_2"

base_1_tree=$(git show -s --format=%T $base_1)
head_2_tree=$(git show -s --format=%T $head_2)

merge_base=`git merge-base $head_1 $base_2` || { echo 1>&2 "Error: couldn't find merge-base(<head_1>, <base_2>)"; exit -1; }
merge_base_tree=$(git show -s --format=%T $merge_base)

if [[ "$merge_base_tree" != "$base_1_tree" ]]; then
  echo 1>&2 "Error: <base_1> is not tree-equal with merge-base(<head_1>, <base_2>)"
  exit -1
fi

# Make note of existing head
current_head=`git branch --show-current`
if [[ -z "$current_head" ]]; then
  current_head=`git rev-parse --verify HEAD`
fi
check_commits_exist "$current_head"

# Stash changes if there are any
if [[ git diff --exit-code @ ]]; then
  git stash push --include-untracked -m "diffsame.sh" || { echo 1>&2 "Error: couldn't stash uncommitted changes"; exit -1; }
  did_stash=1
fi

# Check out base_2 in detached HEAD state
git checkout -d "${base_2}~0" || { echo 1>&2 "Error: couldn't checkout <base_2>"; rtn_value=-1; }

# Attempt to merge head_1 into base_2
if [[ $rtn_value -eq 0 ]]; then
  # Check if merge is clean
  git merge --no-ff --no-edit --no-commit --strategy=resolve $head_1 || { rtn_value=1; }
fi

if [ $rtn_value -eq 0 ] && git diff --exit-code $head_2; then

# if [ $rtn_value -eq 0 ] && git diff --exit-code $head_2; then
#   echo 1>&2 "Test merge had diffs with head_2"
#   exit -1 # Not diffsame
# fi

# Return to previous head
current_head=`git branch --show-current`
if [[ -z "$current_head" ]]; then
  current_head=`git rev-parse --verify HEAD`
fi

if [[ did_stash -eq 1 ]]; then
  git stash pop
fi

## END



  # Possible ways to test for empty merge without actually creating new commit

  # git checkout "${base_2}~0" || return 1
  # git merge --no-ff --no-commit $head_1 || return 1

  # then:
  # git diff --exit-code $head_2 || return 1

  # or maybe:
  # if [[ `git status --porcelain` ]]; then
  #   # Changes
  # else
  #   # No changes
  # fi




  # # Create a test merge
  # git checkout "${base_2}~0" || return 1
  # git merge --no-ff --no-edit $head_1 || return 1
  # local test_merge_tree=$(git show -s --format=%T HEAD)

  # if [ "$test_merge_tree" != "$head_2_tree" ]; then
  #   return 1
  # fi

  # return 0


  # # Stash doesn't do anything with new, unstaged files
  # if [[ git diff --exit-code @ ]]; then
  #   git stash pop
  #   echo 1>&2 "Error: changes found after stash; aborting. Try again with a clean working directory."
  #   exit 6
  # fi


# # Clean merge not possible
# # Check if the merge output is the same as the head_2 tree
# # ** TODO: make diff strict -- force ignore-ws options off, etc
# if [ $rtn_value -eq 0 ] && git diff --exit-code $head_2; then
#   echo 1>&2 "Test merge had diffs with head_2"
#   exit -1 # Not diffsame
# fi

