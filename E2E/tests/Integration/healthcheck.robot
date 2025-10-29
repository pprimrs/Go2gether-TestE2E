*** Settings ***
Library     RequestsLibrary
Resource    ../../resources/keywords.robot
Suite Setup     Setup API Session

*** Test Cases ***
Login API Returns 200
    [Documentation]    Verify that login API works with valid credentials
    ${EMAIL}=    Generate Unique Email
    ${REGISTER}=    Register User    ${EMAIL}    P@ssw0rd123
    Should Be True    ${REGISTER.status_code} in [200, 201]
    ${resp}=    Login User    ${EMAIL}    P@ssw0rd123
    Should Be Equal As Integers    ${resp.status_code}    200
