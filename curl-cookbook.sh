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
https://api.github.localhost/repos/github/public-server/pulls/5/merge

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


## Github-App
## ==========

# Step 1: create JWT on https://jwt.io/#debugger-io

Get pkcs pubkey from pem:
openssl rsa -in testapp1.2022-08-05.private-key.pem -outform PEM -pubout -out testapp1.2022-08-05.private-key.pkcs1

{
  "alg": "RS256",
  "typ": "JWT"
}
{
"iat": 1659819187,
"exp": 1659819847,
"iss": "1"
}

echo \"iat\": $(expr `date +%s` - 60), ; echo \"exp\": $(expr `date +%s` + 600), # now -1min / +10min

app_jwt='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTk5MTAxNzIsImV4cCI6MTY1OTkxMDgzMiwiaXNzIjoiMSJ9.kaeQsXrpbfNlLnPXhE9w-meAnBFj-MW0CcG7r8tZ5u1sfN8Zg7jiPdy26aJwzX17PJpoI_LuH444Od_t1z5oftfDzjMO-t0InupdsiDebznUm2zzDfyxe_KIyqCNlpowpllWKQ5jQTvTumhUaeMbCVN1JXdFimYZAfOFas5jEi8ZQ5QYH3U-rU0BNyqSLJef-ODnf64ZP9yv2tdJOlrIdrVtlzlX7u0BhHeEjtXB8wZeneV6YYlqQ3OqVRsiq3e4rNGCS0PuGwkugPYRY8k8wLz1T6Enp2KAsksnU7f-fPLQJ1bVu4GphdjKlirFTuYSMCCRVsQJysqs_F9x7V8b-Q'
curl -i -X GET \
-H "Authorization: Bearer $app_jwt" \
-H "Accept: application/vnd.github+json" \
https://api.darylcantrell-03d56231eb10a1a11.ghe-test.org/app/installations

# Step 2: use JWT token to get 1hr access token
app_jwt='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTk5MTA1MDEsImV4cCI6MTY1OTkxMTE2MSwiaXNzIjoiMSJ9.RHobHbUeXaczc9iKmmtAJ4pF3cH8sgLZTM4X5Hbx8TPEanglyjQnNtO4tfTG1pIl0kYPLzDeSDhwTDgoZAZ2_weBymx0LlzQHotuQKay-DivyCQCPbMMIM59YAxjTrfJZclMdM4F5Pbw47GdSZ3FsI6jp-d_IeSdwZp_dPQ1a8efl7MOj4boqBUmBa2BzUrTUdoArrRG0JA0UIvOASUUC4vhmhkCDY1XBmyCEMQ3aVst7GZfyB10s9TQZKKJ7AYFFRPTcuQQyBNPj62uDKsRjPrR_x4cPsBgU96qjoFsYYUqIR9zLCsZqpgqoGXiCBf9ex9ttvEjjcECGEWzaBPTZw'
curl -i -X POST \
  -H "Authorization: Bearer $app_jwt" \
  -H "Accept: application/vnd.github+json" \
https://api.darylcantrell-0577bb434cff36aeb.ghe-test.ninja/app/installations/1/access_tokens


# Step 3: Use access token to make API calls as app
token='ghs_n8wBkTXcf9apM6l0UvMog8VZ03ue3U0VZwW0'
curl -i \
 --request POST \
 --header "Authorization: token $token" \
 --header "Content-Type: application/json" \
 --header "Accept: application/vnd.github+json" \
 --data '{
  "state":"success",
  "target_url":"https://example.com/build/status",
  "description":"App status bar",
  "context":"bar"
  }' \
  https://api.darylcantrell-03d56231eb10a1a11.ghe-test.org/repos/Org1/Repo1/statuses/fc3bf2ecc69c65024c610fe0633753ffd47fbcc9
