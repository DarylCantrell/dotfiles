select
  concat('pr.id: ', pr.id, '  [pr.num: ', iss.number, ']  (', cast(pr.head_ref as nchar(300)), ' → ', cast(pr.base_ref as nchar(300)), ')') as pr_id,
  left(pr.base_sha, 8) as pr_base_sha,
  left(pr.head_sha, 8) as pr_head_sha,
  pr.mergeable as pr_mergeable,
  pr.merged_at as pr_merged_at,
  left(pr.merge_commit_sha, 8) as pr_merge_commit_sha,
  -- pr.merge_commit_sha,
  pr.base_sha_on_merge as pr_base_sha_on_merge,
  iss.state as iss_state
from pull_requests pr
join issues iss
  on pr.id = iss.pull_request_id
where
  true\G


select
  concat(pr.id, "  (", cast(pr.head_ref as nchar(300)), " → ", cast(pr.base_ref as nchar(300)), ")") as pr_id,
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
  rvw.created_at as rvw_created,
  rvw.updated_at as rvw_updated,
  case rvw.state
    when 0 then '0:pending'     when 1 then '1:commented'    when 30 then '30:changes_requested'
    when 40 then '40:approved'  when 50 then '50:dismissed'  else rvw.state
  end as rvw_state
from pull_requests pr
left outer join pull_request_reviews rvw
  on pr.id = rvw.pull_request_id
where
  true\G

