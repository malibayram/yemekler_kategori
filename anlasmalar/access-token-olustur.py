from oauth2client.service_account import ServiceAccountCredentials

SCOPES = ['https://www.googleapis.com/auth/firebase.messaging']

credentials = ServiceAccountCredentials.from_json_keyfile_name('./sendika-fc29d-firebase-adminsdk-igf3y-a08107e6c4.json', SCOPES)
access_token_info = credentials.get_access_token()

print(access_token_info.access_token)