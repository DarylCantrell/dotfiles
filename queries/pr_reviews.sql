select
  concat(pr.id, "  ", base_ref, " → ", head_ref) as pr_id,
  left(pr.base_sha, 8) as pr_base_sha,
  left(pr.head_sha, 8) as pr_head_sha,
  left(pr.merge_commit_sha, 8) as pr_merge_commit_sha,
  pr.base_sha_on_merge as pr_base_sha_on_merge
from github_development_issues_pull_requests.pull_requests pr
where
  true\G
