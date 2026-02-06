*** Settings ***
Resource    resources/Resources.resource
Library    libraries/AppiumServerManager.py

*** Keywords ***
Open Android App
    ${remote}    Get Appium Server Url
    &{caps}    Get Merged Caps

    Open Application    ${remote}    &{caps}

Close Android App
    Close Application
    Stop Appium If Started

Setup Test Environment
    Start Appium If Needed
    Open Android App

Swipe Down Until Element Visible
    [Arguments]    ${locator}
    Wait Until Keyword Succeeds    10s    500ms
    ...    Swipe Down And Check Element    ${locator}

Swipe Down And Check Element
    [Arguments]    ${locator}
    ${status}=    Run Keyword And Return Status    Page Should Contain Element    xpath=${locator}
    IF    not ${status}
        Swipe Down
    END
    RETURN    ${status}

Swipe Down
    Swipe By Percent    50    80    50    20    1s