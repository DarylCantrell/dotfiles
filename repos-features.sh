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
bin/toggle-feature-flag enable code_quality_org_settings

# Push-rules ignore paths
bin/toggle-feature-flag enable rule_ignored_file_paths
bin/toggle-feature-flag enable rule_ignored_file_paths_enforce

# PoP
bin/toggle-feature-flag enable proof_of_presence
# bin/toggle-feature-flag enable proof_of_presence_cosmos
# bin/toggle-feature-flag enable proof_of_presence_security_key
# bin/toggle-feature-flag enable proof_of_presence_saml_all_idps
bin/toggle-feature-flag enable proof_of_presence_ruleset_enforcement
bin/toggle-feature-flag enable proof_of_presence_ruleset
bin/toggle-feature-flag enable proof_of_presence_pr_rollout
bin/toggle-feature-flag enable proof_of_presence_enforcement
bin/toggle-feature-flag enable proof_of_presence_graphql

# stacks
bin/toggle-feature-flag enable pull_request_stacks
bin/toggle-feature-flag enable pull_request_stacks_async_merge
bin/toggle-feature-flag enable pull_request_stacks_batch_merge_commit_validation
bin/toggle-feature-flag enable pull_request_stacks_direct_merge_queued_ancestor_message
bin/toggle-feature-flag enable pull_request_stacks_disable_auto_merge_on_failure
bin/toggle-feature-flag enable pull_request_stacks_effective_entry_statuses
bin/toggle-feature-flag enable pull_request_stacks_feedback_dialog
bin/toggle-feature-flag enable pull_request_stacks_mq_squash
bin/toggle-feature-flag enable pull_request_stacks_new_rebasing_ui
bin/toggle-feature-flag enable pull_request_stacks_preserve_signatures_on_rebase
bin/toggle-feature-flag enable pull_request_stacks_rebase_defer_push_jobs
bin/toggle-feature-flag enable pull_request_stacks_rebase_without_merge_commit
bin/toggle-feature-flag enable pull_request_stacks_rest_api
bin/toggle-feature-flag enable pull_request_stacks_show_all_entries_statuses
bin/toggle-feature-flag enable pull_request_stacks_stop_skipping_checks
bin/toggle-feature-flag enable pull_request_stacks_thorough_auto_merge_check
bin/toggle-feature-flag enable pull_request_stacks_timeline_events
bin/toggle-feature-flag enable pull_request_stacks_update_merge_conflict_and_rebase_ui

# bin/toggle-feature-flag enable pull_request_stacks_mq_allowlist                  # partially shipped partially staffshipped
# bin/toggle-feature-flag enable pull_request_stacks_mq_no_squash                  # partially shipped partially staffshipped
# bin/toggle-feature-flag enable pull_request_stacks_navigation_shortcuts          # partially shipped staffshipped
# bin/toggle-feature-flag enable pull_request_stacks_opt_out                       # partially shipped not staffshipped
# bin/toggle-feature-flag enable pull_request_stacks_ref_update_base_missing_error # partially shipped not staffshipped
# bin/toggle-feature-flag enable pull_request_stacks_retarget_base_on_delete       # partially shipped staffshipped
# bin/toggle-feature-flag enable pull_request_stacks_review_promotion              # partially shipped not staffshipped

# bin/toggle-feature-flag enable pull_request_stacks_effective_status_rule_evaluation # partially shipped not staffshipped
# bin/toggle-feature-flag enable pull_request_stacks_hide_ineligible_add_action       # disabled not staffshipped
# bin/toggle-feature-flag enable pull_request_stacks_pancake_icon                     # disabled not staffshipped
