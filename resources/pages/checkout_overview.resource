*** Settings ***
Resource    resources/locators/checkout_overview_loc.resource

*** Keywords ***
Verify Checkout Data
    Verify Product Name
    Verify Product Quantity
    Verify Product Price

Verify Product Quantity
    Element Text Should Be    ${ITEMS_QUANTITY_LOC}  ${NUMBER_OF_ITEMS_IN_CART}
        
Verify Product Name
    ${loc}  Catenate  ${ITEMS_DESCRIPTION_LOC}//*[@text="${TEST_PRODUCT_NAME}"]
    Wait Until Visible    ${loc}

Verify Product Price
    Element Text Should Be    ${ITEMS_PRICE_LOC}  ${TEST_PRODUCT_PRICE}

Scroll To Finish And Click
    Swipe Down Until Element Visible    ${FINISH_BUTTON_LOC}
    Click Button    ${FINISH_BUTTON_LOC}


