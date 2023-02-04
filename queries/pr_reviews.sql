select
  concat(pr.id, "  (", pr.head_ref, " → ", pr.base_ref, ")") as pr_id,
  left(pr.base_sha, 8) as pr_base_sha,
  left(pr.head_sha, 8) as pr_head_sha,
  pr.mergeable as pr_mergeable,
  -- left(pr.merge_commit_sha, 8) as pr_merge_commit_sha,
  pr.merge_commit_sha,
  pr.base_sha_on_merge as pr_base_sha_on_merge,
  iss.state as iss_state
from github_development_issues_pull_requests.pull_requests pr
join github_development_issues_pull_requests.issues iss
  on pr.id = iss.pull_request_id
where
  true\G


select
  concat(pr.id, "  (", pr.head_ref, " → ", pr.base_ref, ")") as pr_id,
  left(pr.base_sha, 8) as pr_base_sha,
  left(pr.head_sha, 8) as pr_head_sha,
  pr.mergeable as pr_mergeable,
  -- left(pr.merge_commit_sha, 8) as pr_merge_commit_sha,
  pr.merge_commit_sha,
  pr.base_sha_on_merge as pr_base_sha_on_merge,
  rvw.id as rvw_id,
  rvw.user_id as rvw_user_id,
  left(rvw.head_sha, 8) as rvw_head_sha,
  left(rvw.merge_base_sha, 8) as rvw_merge_base_sha,
  case rvw.state
    when 0 then '0:pending'     when 1 then '1:commented'    when 30 then '30:changes_requested'
    when 40 then '40:approved'  when 50 then '50:dismissed'  else rvw.state
  end as rvw_state
from github_development_issues_pull_requests.pull_requests pr
left outer join github_development_issues_pull_requests.pull_request_reviews rvw
  on pr.id = rvw.pull_request_id
where
  true\G

