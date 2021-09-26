import argparse
import json
import requests

from oauth2client.service_account import ServiceAccountCredentials

SCOPES = ['https://www.googleapis.com/auth/firebase.messaging']

credentials = ServiceAccountCredentials.from_json_keyfile_name('/Users/mab/Downloads/yemekkategori-firebase-adminsdk-27jq1-e51e49e814.json', SCOPES)
access_token_info = credentials.get_access_token()

print(access_token_info.access_token)