import http.client, urllib.request, urllib.parse
params = urllib.parse.urlencode ({'command': 'LoadGame', 'GameID': 5})
headers = {"Content-type": "application/x-www-form-urlencoded",
        "Accept": "text/plain"}
conn = http.client.HTTPConnection("http://85.8.7.133:80/game/index.php")
conn.request("POST", "", params, headers)
response = conn.getresponse()

data = response.read()
data
conn.close()
