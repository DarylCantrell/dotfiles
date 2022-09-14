if [[ $# != 3 ]]; then
  echo "Usage: gentoken <private-key-file> <app-id> <installation-id>"
  exit 1
fi

privKeyFile=$1
appId=$2
instId=$3

base64Encode() { base64 --wrap=0 | tr '+/' '-_' | tr -d '='; }

pubKeyFile=${privKeyFile%.pem}.pkcs1

if [[ ! -f $pubKeyFile ]]; then
  openssl rsa -in $privKeyFile -outform PEM -pubout -out $pubKeyFile
fi

header='{
  "alg": "RS256",
  "typ": "JWT"
}'
headerB64=$(echo -n $header | base64Encode)

payload='{
  "iat": '$(expr `date +%s` - 60)',
  "exp": '$(expr `date +%s` + 600)',
  "iss": "'$appId'"
}'
payloadB64=$(echo -n $payload | base64Encode)

signedContent="${headerB64}.${payloadB64}"
signature=$(printf %s "$signedContent" | openssl dgst -sha256 -sign $privKeyFile | base64Encode)

jwt="${signedContent}.${signature}"

curlOutput=$(curl -s --fail-with-body -X POST \
  -H "Authorization: Bearer $jwt" \
  -H "Accept: application/vnd.github+json" \
http://api.github.localhost/app/installations/$instId/access_tokens)

if [[ $? != 0 ]]; then
  echo "$curlOutput" 1>&2
  exit 1
fi

jq -r '.token' <<< "$curlOutput"
