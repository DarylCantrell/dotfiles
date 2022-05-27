select
  role_id,
  roles.name as role_name,
  roles.owner_id,
  owner_type,
  u_own.login as owner_login,
  target_id,
  target_type,
  coalesce(u_tgt.login, repo.name) as target,
  actor_id,
  actor_type,
  u_act.login as actor_login
from user_roles
join roles
  on user_roles.role_id = roles.id
left join github_development.users u_act
  on actor_type = u_act.type and actor_id = u_act.id
left outer join github_development.users u_own
  on owner_type = u_own.type and owner_id = u_own.id
left outer join github_development.users u_tgt
  on target_type = u_tgt.type and target_id = u_tgt.id
left outer join github_development_repositories.repositories repo
  on target_type = 'Repository' and target_id = repo.id
order by target_id;
