*** Settings ***
Resource   resources/keywords/common_page.resource
Resource    resources/locators/login_loc.resource


*** Keywords ***
Fill Login Name
    [Arguments]    ${login_name}
    Fill Input    ${USERNAME_LOC}  ${login_name}

Fill Password 
    [Arguments]    ${password_string}
    Fill Input    ${PASSWORD_LOC}  ${password_string}

Login User
    [Arguments]    ${login_name}  ${password_string}
    Fill Login Name    ${login_name}
    Fill Password     ${password_string}

Login With Standard Credentials
    ${login}  ${password}  Get Credentials For  standard_user
    Login User  ${login}  ${password}
    Click Button    ${LOGIN_LOC}
    Wait Until Page Contains    PRODUCTS