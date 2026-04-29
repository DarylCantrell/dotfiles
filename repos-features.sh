# ?
bin/toggle-feature-flag enable new_restricted_commits_rule
bin/toggle-feature-flag enable rule_pr_required_reviewers_filter_suggestions
bin/toggle-feature-flag enable rule_pr_required_reviewers_enforce

# Org- and ent-level "repo rules"
bin/toggle-feature-flag enable repo_policy_bypass
bin/toggle-feature-flag enable member_privilege_rulesets

# Ent teams as bypassers
bin/toggle-feature-flag enable enterprise_rulesets_enterprise_teams

# Relaxed rename ruleset protections
bin/toggle-feature-flag enable org_rules_relaxed_rename
bin/toggle-feature-flag enable rule_insights_branch_rename_annotation
bin/toggle-feature-flag enable ent_rules_relaxed_rename
bin/toggle-feature-flag enable branch_rename_enterprise_rule_protections_enforce
bin/toggle-feature-flag enable branch_rename_enterprise_rule_protections
