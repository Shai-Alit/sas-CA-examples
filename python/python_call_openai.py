
import requests
import json
def is_valid_json(payload: str) -> bool:
    try:
        json.loads(payload)
        return True
    except json.JSONDecodeError:
        return False
    except TypeError:  # in case someone passes None or non-string
        return False

with open('/mnt/mtes-tt-file-share/data/P_FORD/git/ssh/creds.json','rb') as f:
    creds = json.load(f)


payload = '''{
"model" : "gpt-5.4-mini",
"input":[{"role":"user","content" : "Tell me a short summary of what SAS Institute is best known for."}],
"instructions" : "do not use or create offensive or racists content",
"tools" : [{"type": "web_search_preview"}],
"reasoning": {"effort": "low","summary": "auto"},
"store":true
}'''

input_tokens = -1
output_tokens = -1
response_id = 'NA'

API_KEY = creds['creds']['api_key_restricted']
url = "https://api.openai.com/v1/responses"

headers = {"Authorization": f"Bearer {API_KEY}","Content-Type": "application/json"}

output_str = 'nothing ran'
if is_valid_json(payload):
    response = requests.post(url,headers=headers,json=json.loads(payload))
    
    if response.status_code == 200:
            result = response.json()
            try:
                for r in result["output"]:
                    if r['type'] == 'message':
                        output_str = r["content"][0]["text"]
                        response_id = result["id"]
                        input_tokens = int(result["usage"]["input_tokens"])
                        output_tokens = int(result["usage"]["output_tokens"])
                        break

            except Exception as e:
                output_str = str(e)

    else:
            output_str = f'Error {response.status_code}: {response.text}'
else:
    output_str = f'Invalid payload. Must be JSON format enclosed in single quotes. Payload was:\n {payload}'


print(output_str)