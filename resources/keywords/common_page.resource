*** Settings ***
Library    AppiumLibrary
Library    libraries/UserConfigParser.py


*** Keywords ***
Wait Until Visible
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    ${timeout}

Click Button
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}
    Click Element         ${locator}

Fill Input
    [Arguments]    ${locator}  ${text}
    Wait Until Visible    ${locator}
    Input Text    ${locator}  ${text}

Get Credentials For
    [Arguments]    ${user_profile}
    ${username}    ${password}    Get User    ${user_profile}
    RETURN    ${username}    ${password}