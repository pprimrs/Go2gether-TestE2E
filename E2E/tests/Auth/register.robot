*** Settings ***
Documentation     Registration test suite for new users
Resource          ../../resources/keywords.robot
Suite Setup       Setup API Session
Force Tags        register

*** Test Cases ***
Register with valid information
    [Documentation]    Verify user registration with valid name, email, and password
    [Tags]    register    positive
    ${EMAIL}=    Generate Unique Email
    ${resp}=    Register User    ${EMAIL}    P@ssw0rd123
    Should Be True    ${resp.status_code} in [200, 201]

Register with existing email
    [Documentation]    Verify system prevents registration with duplicate email
    [Tags]    register    negative
    ${EMAIL}=    Generate Unique Email
    Register User    ${EMAIL}    P@ssw0rd123
    ${resp}=    Register User    ${EMAIL}    P@ssw0rd123
    Should Be True    ${resp.status_code} in [400, 409]

Register with missing password
    [Documentation]    Verify registration fails when required field is missing
    [Tags]    register    negative
    ${EMAIL}=    Generate Unique Email
    ${payload}=    Create Dictionary    email=${EMAIL}
    ${resp}=    POST On Session    api    /api/auth/register    json=${payload}    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    400
