# Copilot Enterprise Rules
bin/toggle-feature-flag enable copilot_model_registry_stafftools
bin/toggle-feature-flag enable stafftools_copilot_rules_resync
bin/toggle-feature-flag enable use_setting_rules_copilot_models
bin/toggle-feature-flag enable copilot_default_models_app

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
bin/toggle-feature-flag enable use_relaxed_rename_for_default_switch

# Settings / code quality
bin/toggle-feature-flag enable code_quality_org_targeting
bin/toggle-feature-flag enable code_quality_turboscan_job_enablement
bin/toggle-feature-flag enable settings_sdk_listeners
bin/toggle-feature-flag enable code_quality_new_repo_selection_card
bin/toggle-feature-flag enable code_quality_org_targeting_stafftools
