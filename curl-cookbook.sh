exit

collab_pat='collaborator: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'

# Merge existing PR -- data args are all optional
curl -u $collab_pat \
 --request PUT \
 --header "Content-Type: application/json" \
 --data '{
  "commit_title": "commit_title",
  "commit_message": "commit_message",
  "sha": "cf2adc2b8ee9dbe4a3463754c6c2c1014e012060",
  "merge_method": "merge"
}' \
http://api.github.localhost/repos/github/public-server/pulls/5/merge

# Get merge commit for existing PR
pr_getmerge() {
  curl -s -X GET \
    -H "Authorization: Bearer $2" \
  http://api.github.localhost/repos/github/public-server/pulls/$1 | jq -r .merge_commit_sha
}

# Post status to commit
# error, failure, pending, success
collab_pat='ghe-admin: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'
curl -u $collab_pat \
 --request POST \
 --header "Content-Type: application/json" \
 --header "Accept: application/vnd.github+json" \
 --data '{
  "state":"success",
  "target_url":"https://example.com/build/status",
  "description":"PAT status baz",
  "context":"baz"
  }' \
  https://api.darylcantrell-03d56231eb10a1a11.ghe-test.org/repos/Org1/Repo1/statuses/fc3bf2ecc69c65024c610fe0633753ffd47fbcc9


# List branches
curl -u :ghs_ggxgK9JlqFS1AH6ROOsq603g4HiCwy45BoGh \
 --request GET \
 --header "Content-Type: application/json" \
 --header "Accept: application/vnd.github+json" \
http://api.github.localhost/repos/github/public-server/branches


# Rename branch
curl -u :ghs_ggxgK9JlqFS1AH6ROOsq603g4HiCwy45BoGh \
 --request POST \
 --header "Content-Type: application/json" \
 --header "Accept: application/vnd.github+json" \
 --data '{"new_name":"topic8"}' \
http://api.github.localhost/repos/github/public-server/branches/topic7/rename


getbp() {
  curl -i \
  --request GET \
  --header "Authorization: token $2" \
  --header "Accept: application/vnd.github+json" \
  http://api.github.localhost/repos/github/public-server/branches/$1/protection
}


## Github-App
## ==========

# Step 0: Go to GH App page and get:

- App ID from top of page
- Private key from bottom of page

# Step 1: Extract pkcs pubkey from pem private key

openssl rsa -in testapp1.2022-08-05.private-key.pem -outform PEM -pubout -out testapp1.2022-08-05.public-key.pkcs1

# Step 2: create JWT at https://jwt.io/#debugger-io (switch dropdown to RS256)

echo \"iat\": $(expr `date +%s` - 60), ; echo \"exp\": $(expr `date +%s` + 600), # now -1min / +10min

# Use app id as "iss" value. JWT contents should look like this:

HEADER:
{
  "alg": "RS256",
  "typ": "JWT"
}
PAYLOAD:
{
"iat": 1659819187,
"exp": 1659819847,
"iss": "1"
}

# Step 3 (possibly skippable): Get installation id from list of places where app has been installed
# NOTE: This shows you all installations for an app. If you have only one installation of interest,
# a short cut is going to http://localhost/ORG/REPO/settings/installations, click Configure on the
# app and look at the URL for the installation id. Then skip to step 4.

app_jwt='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTk5MTAxNzIsImV4cCI6MTY1OTkxMDgzMiwiaXNzIjoiMSJ9.kaeQsXrpbfNlLnPXhE9w-meAnBFj-MW0CcG7r8tZ5u1sfN8Zg7jiPdy26aJwzX17PJpoI_LuH444Od_t1z5oftfDzjMO-t0InupdsiDebznUm2zzDfyxe_KIyqCNlpowpllWKQ5jQTvTumhUaeMbCVN1JXdFimYZAfOFas5jEi8ZQ5QYH3U-rU0BNyqSLJef-ODnf64ZP9yv2tdJOlrIdrVtlzlX7u0BhHeEjtXB8wZeneV6YYlqQ3OqVRsiq3e4rNGCS0PuGwkugPYRY8k8wLz1T6Enp2KAsksnU7f-fPLQJ1bVu4GphdjKlirFTuYSMCCRVsQJysqs_F9x7V8b-Q'

curl -i -X GET \
  -H "Authorization: Bearer $app_jwt" \
  -H "Accept: application/vnd.github+json" \
http://api.github.localhost/app/installations

#https://api.darylcantrell-03d56231eb10a1a11.ghe-test.org/app/installations

# Step 4: Use JWT token and installation id to create 1hr access token for that installation.

curl -i -X POST \
  -H "Authorization: Bearer $app_jwt" \
  -H "Accept: application/vnd.github+json" \
http://api.github.localhost/app/installations/**installation_id from above**/access_tokens

#https://api.darylcantrell-0577bb434cff36aeb.ghe-test.ninja/app/installations/1/access_tokens

# Step 5: Use 1hr access token to make API calls as app

poststat() {
  curl -i \
    --request POST \
    --header "Authorization: token $2" \
    --header "Content-Type: application/json" \
    --header "Accept: application/vnd.github+json" \
    --data '{
      "state":"success",
      "target_url":"https://example.com/build/status",
      "description":"Status '$3'",
      "context":"foo"
    }' \
    https://api.darylcantrell-0348810741b29a732.ghe-test.com/repos/org1/repo1/statuses/$1
}
#  http://api.github.localhost/repos/Org1/Repo1/statuses/$1
#  https://api.darylcantrell-03d56231eb10a1a11.ghe-test.org/repos/Org1/Repo1/statuses/$1

# Make a private test repo
mkprv() {
  curl -i \
  --request POST \
  --header "Authorization: token $token3" \
  --header "Content-Type: application/json" \
  --header "Accept: application/vnd.github+json" \
  --data '{
    "description": "desc",
    "homepage": "https://google.com",
    "private": true,
    "auto_init": true,
    "name": "prv_test_'$1'" }' \
  http://api.github.localhost/orgs/github/repos
}

# Create branch protection
mkbp() {
  curl -i \
  --request PUT \
  --header "Authorization: token $2" \
  --header "Content-Type: application/json" \
  --header "Accept: application/vnd.github+json" \
  --data '{
    "required_status_checks": null,
    "required_pull_request_reviews": {
      "required_approving_review_count": '$3'
    },
    "restrictions": null,
    "enforce_admins": false
  }' \
  http://api.github.localhost/repos/github/public-server/branches/$1/protection
}

# Get branch protection
getbp() {
  curl -i \
  --request GET \
  --header "Authorization: token $2" \
  --header "Accept: application/vnd.github+json" \
  http://api.github.localhost/repos/github/public-server/branches/$1/protection
}

# Delete branch protection
rmbp() {
  curl -i \
  --request DELETE \
  --header "Authorization: token $2" \
  --header "Content-Type: application/json" \
  --header "Accept: application/vnd.github+json" \
  http://localhost/github/public-server/settings/branch_protection_rules/$1
}

  http://api.github.localhost/repos/github/public-server/branches/$1/protection


    "required_signatures": false,
    "enforce_admins": false,
    "required_linear_history": false

"required_pull_request_reviews":{"dismissal_restrictions":{"users":["octocat"],"teams":["justice-league"]},"dismiss_stale_reviews":true,"require_code_owner_reviews":true,"required_approving_review_count":2,"bypass_pull_request_allowances":{"users":["octocat"],"teams":["justice-league"]}},"restrictions":{"users":["octocat"],"teams":["justice-league"],"apps":["super-ci"]},"required_linear_history":true,"allow_force_pushes":true,"allow_deletions":true,"block_creations":true,"required_conversation_resolution":true}'
Response
