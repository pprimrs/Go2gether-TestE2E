*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           String
Library           OperatingSystem
Variables         ../resources/environment.py

*** Variables ***
# เพิ่มค่าเริ่มต้นให้ไม่ขึ้นแดงใน VS Code
${BASE_URL}    http://localhost:8080
${HEADERS}     {"Content-Type": "application/json"}

*** Keywords ***
# ---------- Infra ----------
Setup API Session
    Create Session    api    ${BASE_URL}    headers=${HEADERS}

Generate Unique Email
    ${ts}=    Get Time    epoch
    ${email}=    Set Variable    meow+${ts}@example.com
    [Return]    ${email}

# ---------- JSON helper (แทน JSONLibrary) ----------
Parse JSON
    [Arguments]    ${response}
    ${text}=    Evaluate    $response.text
    ${obj}=     Evaluate    __import__('json').loads($text)
    [Return]    ${obj}

# ---------- Auth APIs ----------
Register User
    [Arguments]    ${email}    ${password}
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${resp}=    POST On Session    api    /api/auth/register    json=${payload}    expected_status=any
    [Return]    ${resp}

Register Without Field
    [Arguments]    ${email}
    ${payload}=    Create Dictionary    email=${email}
    ${resp}=    POST On Session    api    /api/auth/register    json=${payload}    expected_status=any
    [Return]    ${resp}

Login User
    [Arguments]    ${email}    ${password}
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${resp}=    POST On Session    api    /api/auth/login    json=${payload}    expected_status=any
    [Return]    ${resp}

Extract Access Token
    [Arguments]    ${response}
    ${body}=    Parse JSON    ${response}

    # ดึง token ตามรูปแบบที่พบบ่อย (ของคุณคือ 'token' บนสุด)
    ${token}=    Evaluate    ($body.get('token') or ($body.get('data') or {}).get('token') or $body.get('access_token') or $body.get('accessToken') or ($body.get('data') or {}).get('access_token') or ($body.get('data') or {}).get('accessToken'))

    Run Keyword If    '${token}'=='None'    Log    LOGIN RESPONSE BODY: ${body}    WARN
    Should Not Be Empty    ${token}
    [Return]    ${token}


Get Profile
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resp}=    GET On Session    api    /api/auth/profile    headers=${headers}    expected_status=any
    [Return]    ${resp}

Forgot Password
    [Arguments]    ${email}
    ${payload}=    Create Dictionary    email=${email}
    ${resp}=    POST On Session    api    /api/auth/forgot-password    json=${payload}    expected_status=any
    [Return]    ${resp}

Get OTP (for testing)
    [Arguments]    ${email}
    ${payload}=    Create Dictionary    email=${email}
    ${resp}=    POST On Session    api    /api/auth/get-otp    json=${payload}    expected_status=any
    ${body}=    Parse JSON    ${resp}
    ${code}=    Evaluate    $body.get('code')
    [Return]    ${code}

Verify OTP -> Reset Token
    [Arguments]    ${email}    ${code}
    ${payload}=    Create Dictionary    email=${email}    code=${code}
    ${resp}=    POST On Session    api    /api/auth/verify-otp    json=${payload}    expected_status=any
    ${body}=    Parse JSON    ${resp}
    ${reset_token}=    Evaluate    $body.get('reset_token')
    [Return]    ${resp}    ${reset_token}

Reset Password With Token
    [Arguments]    ${reset_token}    ${new_password}
    ${payload}=    Create Dictionary    reset_token=${reset_token}    new_password=${new_password}
    ${resp}=    POST On Session    api    /api/auth/reset-password    json=${payload}    expected_status=any
    [Return]    ${resp}
