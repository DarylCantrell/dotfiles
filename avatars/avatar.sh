
curl \
  --request POST \
  -s --fail-with-body \
  --header "Accept: application/vnd.github+json" \
  --header "Authorization: token `cat /workspaces/pat.collab`" \
  -F 'content_type=image/jpeg' \
  -F 'owner_type=User' \
  -F 'owner_id=147' \
  -F 'avatar_upload=@/workspaces/.codespaces/.persistedshare/dotfiles/Olaf_orig.jpg' \
  "http://localhost/upload/policies/avatars"


^^^^ WON'T WORK this doesn't work because it's not an API call, needs cookies turned on, etc.


New approach to try:

  Blob is stored by alambic service (in overmind)
  Upload image file as avatar
  Look for a new file in alambic's store: /workspaces/github/tmp/objects/_/__/__
  Manually add rows to storage_blob and avatar tables
  Profit...???

