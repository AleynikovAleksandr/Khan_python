import redis
import json

REDIS_URL = "redis://alex:Аа27009990@localhost:6379/0"  
REDIS_KEY = "cloud_security"  
JSON_FILE_PATH = "/home/alex_a/distri_mesh/AWS_ShieldWall/aws_shieldwall.json"

r = redis.Redis.from_url(REDIS_URL, decode_responses=True)

with open(JSON_FILE_PATH, "r", encoding="utf-8") as f:
    cloud_security_json = json.load(f)

r.set(REDIS_KEY, json.dumps(cloud_security_json, ensure_ascii=False))
print(f"JSON успешно сохранён под ключом '{REDIS_KEY}' в Redis.")

retrieved_json = r.get(REDIS_KEY)
if retrieved_json:
    data = json.loads(retrieved_json)
    print("JSON успешно считан из Redis:")
    print(json.dumps(data, indent=2, ensure_ascii=False))
else:
    print("Ключ не найден в Redis.")