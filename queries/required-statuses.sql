select
  repo.id as repo_id,
  repo.name as repo_name,
  prot.id as branch_id,
  prot.name as branch_pat,
  stat.id as stat_id,
  stat.context,
  stat.integration_id as integ_id,
  integ.name as integ_name,
  integ.owner_id as integ_owner_id,
  integ.owner_type as integ_owner_type,
  integ.slug as integ_slug
from github_development_repositories.repositories repo
join github_development_repositories.protected_branches prot
  on repo.id = prot.repository_id
left outer join github_development_repositories.required_status_checks stat
  on prot.id = stat.protected_branch_id
left outer join github_development.integrations integ
  on stat.integration_id = integ.id
where
  repo.name = 'public-server';
