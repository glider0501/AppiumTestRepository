*** Settings ***
Resource    resources/locators/checkout_complete.resource
Resource    resources/Resources.resource

*** Keywords ***
Placed Order Confirmed
    Wait Until Element Is Visible    ${CHECKOUT_COMPLETE}
