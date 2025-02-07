curl https://omdvnndbinvvdjvwmkfh.supabase.co/rest/v1/
api_keys='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9tZHZubmRiaW52dmRqdndta2ZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg2NzQ5MTYsImV4cCI6MjA1NDI1MDkxNn0.QncUqJIvrcgyigrAyamuAEGun-8K-Z3xOzyb2uwkh2I'

encoded_data='NTRhYTliMjMtODllZC00OTE3LWI2YWMtN2FhYTI4YjNmOGE0Ojk3N2EwNjZl LWMyNmYtNDc5MS04NzgxLTUzYTYzYTViODJlYQ=='
oauth_token_url='https://users.fcmlabtest.com/api/oauth2'
api_url='https://atom-api.fcmlabtest.com/api/v2/custom_fields?parent_type=Company&parent_id=3d098b49-d5b3-41c5-ac2c-bfcf872f59aa'


response=$(curl --location $oauth_token_url \
  --header "Authorization: $encoded_data" \
  --form 'grant_type="client_credentials"' \
  --form 'aud="atom-api.3mundi.com"' \
  --form 'scp="companies:view"')

echo "Response"
echo $response
#previous_token=$(cat ./previous_token.data)
#echo "Previous token ${previous_token}"

access_token=$(echo $response | jq -r '.access_token')

echo "Access token ${access_token}"

curl --location $api_url \
--header "Authorization: Bearer $access_token" \
--header 'outputs: human_name'
