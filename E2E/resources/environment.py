from dotenv import load_dotenv
import os

load_dotenv()

# เปลี่ยนพอร์ต/โดเมนให้ตรงกับแบ็กเอนด์ของคุณ
BASE_URL = os.getenv("BASE_URL", "http://localhost:8080")

# ค่าพื้นฐานสำหรับทดสอบ
DEFAULT_PASSWORD = os.getenv("DEFAULT_PASSWORD", "P@ssw0rd123")
NEW_PASSWORD = os.getenv("NEW_PASSWORD", "P@ssw0rd123_NEW")

HEADERS = {"Content-Type": "application/json"}
