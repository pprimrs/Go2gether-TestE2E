*** Settings ***
Documentation     End-to-end auth flow
Resource          ../../resources/keywords.robot
Suite Setup       Setup API Session
Force Tags        auth    e2e

*** Variables ***
${DEFAULT_PASSWORD}    Pass1234!
${NEW_PASSWORD}        NewPass999!

*** Test Cases ***
E2E_AUTH_001 Register, login, reset password and login with new password
    ${EMAIL}=    Generate Unique Email

    ${register_resp}=    Register User    ${EMAIL}    ${DEFAULT_PASSWORD}
    Should Be True    ${register_resp.status_code} in [200, 201, 409]

    ${login_resp}=    Login User    ${EMAIL}    ${DEFAULT_PASSWORD}
    Should Be Equal As Integers    ${login_resp.status_code}    200

    ${forgot_resp}=    Forgot Password    ${EMAIL}
    Should Be Equal As Integers    ${forgot_resp.status_code}    200

    ${otp}=    Get OTP (for testing)    ${EMAIL}
    ${verify_resp}    ${reset_token}=    Verify OTP -> Reset Token    ${EMAIL}    ${otp}
    Should Be Equal As Integers    ${verify_resp.status_code}    200

    ${reset_resp}=    Reset Password With Token    ${reset_token}    ${NEW_PASSWORD}
    Should Be Equal As Integers    ${reset_resp.status_code}    200

    ${login_new}=    Login User    ${EMAIL}    ${NEW_PASSWORD}
    Should Be Equal As Integers    ${login_new.status_code}    200
