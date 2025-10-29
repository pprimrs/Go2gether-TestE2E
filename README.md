# 🤖 Go2gether E2E Test

End-to-End (E2E) testing project for **Go2gether** using **Robot Framework**.  
This repository contains automated test scripts for core features like authentication, user flows, and API validation.

---

## 📦 Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/Go2gether-TestE2E.git
   cd Go2gether-TestE2E

2. **Create virtual environment**
   ```bash
   python -m venv robotenv
   source robotenv/bin/activate   # macOS / Linux
   robotenv\Scripts\activate      # Windows

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt

## 🚀 Run Tests

1. **Run a specific test file**
   ```bash
   robot tests/AuthE2E.robot

---
   
After running, reports will be generated automatically:
 - log.html – detailed execution log
 - report.html – summary report
 - output.xml – raw test result file

  
## 🧩 Tech Stack
 - Robot Framework
 - RequestsLibrary
 - JSONLibrary
 - Collections / OperatingSystem Libraries

---

## 🧪 Test Cases 

### login.robot
| No. | Test Case | Tags | Expected |
|---|---|---|---|
| 1 | **Login with valid email and password** | `login`, `positive`, `smoke` | **200** and token returned |
| 2 | **Login with wrong password** | `login`, `negative` | **401** |

### register.robot
| No. | Test Case | Tags | Expected |
|---|---|---|---|
| 1 | **Register with valid information** | `register`, `positive` | **200/201** |
| 2 | **Register with existing email** | `register`, `negative` | **400/409** |
| 3 | **Register with missing password** | `register`, `negative` | **400** |

### password.robot
| No. | Test Case | Tags | Expected |
|---|---|---|---|
| 1 | **Forgot password with registered email** | `password`, `positive` | **200** |
| 2 | **Reset password successfully via OTP** | `password`, `positive` | **200** |

**Total:** 7 cases

---

## 📁 Project Structure
  ```bash
Go2gether-TestE2E/
│
├── E2E/
│   ├── resources/
│   │   ├── environment.py
│   │   └── keywords.robot
│   │
│   └── tests/
│       └── Auth/
│           ├── login.robot
│           ├── password.robot
│           └── register.robot
│
├── reports/                 # Generated test reports
├── robotenv/                # Virtual environment
├── .env                     # Environment variables
├── .gitignore
├── .gitattributes
├── log.html
├── report.html
├── output.xml
└── requirements.txt


