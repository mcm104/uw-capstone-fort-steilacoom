import requests
import json
import base64

wordpress_user = # username
wordpress_password = # password
wordpress_credentials = wordpress_user + ":" + wordpress_password
wordpress_token = base64.b64encode(wordpress_credentials.encode())
wordpress_header = {'Authorization': 'Basic ' + wordpress_token.decode('utf-8')}

wordpress_url = 'https://uwhistorynerds.wordpress.com/wp-json/wp/v2'

page_id = '1'

page_to_add = {
	'status': 'private',
	'title': 'test',
	'content': 'test2'
}

response = requests.post(wordpress_url + page_id , headers=wordpress_header, json=page_to_add)

print(response.status_code)
print(response.json())
