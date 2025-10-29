*** Settings ***
Library     RequestsLibrary
Resource    ../../resources/keywords.robot
Suite Setup     Setup API Session

*** Test Cases ***
Login API Returns 200
    [Documentation]    Verify that login API works with valid credentials
    ${EMAIL}=    Generate Unique Email
    ${REGISTER}=    Register User    ${EMAIL}    P@ssw0rd123

    # Accept 200/201 (if success) or 409 (have already) 
    IF    ${REGISTER.status_code} in [200, 201]
        Log    Registered new user: ${EMAIL}
    ELSE IF    ${REGISTER.status_code} == 409
        Log    User already exists: ${EMAIL} — proceed to login
    ELSE
        Fail   Unexpected register status: ${REGISTER.status_code}
    END

    ${resp}=    Login User    ${EMAIL}    P@ssw0rd123
    Should Be Equal As Integers    ${resp.status_code}    200
