*** Settings ***
Documentation     Forgot and Reset Password test suite
Resource          ../../resources/keywords.robot
Suite Setup       Setup API Session
Force Tags        password

*** Test Cases ***
Forgot password with registered email
    [Documentation]    Verify that the system sends reset link to registered email
    [Tags]    password    positive
    ${EMAIL}=    Generate Unique Email
    Register User    ${EMAIL}    P@ssw0rd123
    ${resp}=    Forgot Password    ${EMAIL}
    Should Be Equal As Integers    ${resp.status_code}    200

Reset password successfully via OTP
    [Documentation]    Verify user can reset password using OTP
    [Tags]    password    positive
    ${EMAIL}=    Generate Unique Email
    Register User    ${EMAIL}    P@ssw0rd123
    ${resp1}=    Forgot Password    ${EMAIL}
    ${code}=     Get OTP (for testing)    ${EMAIL}
    ${v}    ${reset_token}=    Verify OTP -> Reset Token    ${EMAIL}    ${code}
    ${r}=       Reset Password With Token    ${reset_token}    P@ssw0rd123_NEW
    Should Be Equal As Integers    ${r.status_code}    200
