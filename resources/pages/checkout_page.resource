*** Settings ***
Resource    resources/locators/checkout_loc.resource
Resource    resources/keywords/common_page.resource
Resource    resources/keywords/error_messages.resource
Library    FakerLibrary

*** Keywords ***
Fill Checkout Data
    Generate Checkout Data

    Fill Input    ${NAME_FIELD_LOC}       ${CHECKOUT_FIRST_NAME}
    Fill Input    ${LASTNAME_FIELD_LOC}   ${CHECKOUT_LAST_NAME}
    Fill Input    ${ADDRESS_FIELD_LOC}    ${CHECKOUT_ZIP_CODE}

Generate Checkout Data
    ${first_name}    Get Random Checkout Data    first_name
    ${last_name}     Get Random Checkout Data    last_name
    ${zip_code}      Get Random Checkout Data    zip

    Set Test Variable    ${CHECKOUT_FIRST_NAME}    ${first_name}
    Set Test Variable    ${CHECKOUT_LAST_NAME}     ${last_name}
    Set Test Variable    ${CHECKOUT_ZIP_CODE}      ${zip_code}

Get Random Checkout Data
    [Arguments]    ${data_type}
    IF    '${data_type}' == 'first_name'
        ${value}    First Name
    ELSE IF    '${data_type}' == 'last_name'
        ${value}    Last Name
    ELSE IF    '${data_type}' == 'zip'
        ${value}    Zipcode
    END
    RETURN    ${value}

Continue Checkout
    Click Button    ${CONTINUE_BUTTON_LOC}

Check If Continue Is Unavailable
    Continue Checkout
    Wait Until Visible    ${CHECKOUT_ERROR_MESSAGE_LOC}

Verify Checkout Required Fields
    Check If Continue Is Unavailable
    Element Text Should Be    ${CHECKOUT_ERROR_MESSAGE_LOC}  ${FIRST_NAME_REQUIRED}
    Generate Checkout Data
    Fill Input    ${NAME_FIELD_LOC}       ${CHECKOUT_FIRST_NAME}
    Check If Continue Is Unavailable
    Element Text Should Be    ${CHECKOUT_ERROR_MESSAGE_LOC}  ${LAST_NAME_REQUIRED}

    Fill Input    ${LASTNAME_FIELD_LOC}   ${CHECKOUT_LAST_NAME}
    Check If Continue Is Unavailable
    Element Text Should Be    ${CHECKOUT_ERROR_MESSAGE_LOC}  ${POSTAL_CODE_REQUIRED}
