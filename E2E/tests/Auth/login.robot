*** Settings ***
Documentation     Login test suite for Go2gether authentication
Resource          ../../resources/keywords.robot
Suite Setup       Setup API Session
Force Tags        login

*** Test Cases ***
Login with valid email and password
    [Documentation]    Verify that user can log in successfully with valid credentials
    [Tags]    login    positive    smoke
    ${EMAIL}=    Generate Unique Email
    ${REGISTER}=    Register User    ${EMAIL}    P@ssw0rd123
    Should Be True    ${REGISTER.status_code} in [200, 201]
    ${resp}=    Login User    ${EMAIL}    P@ssw0rd123
    Should Be Equal As Integers    ${resp.status_code}    200

Login with wrong password
    [Documentation]    Verify that login fails when password is incorrect
    [Tags]    login    negative
    ${EMAIL}=    Generate Unique Email
    ${REGISTER}=    Register User    ${EMAIL}    P@ssw0rd123
    Should Be True    ${REGISTER.status_code} in [200, 201]
    ${resp}=    Login User    ${EMAIL}    wrongpass
    Should Be Equal As Integers    ${resp.status_code}    401


