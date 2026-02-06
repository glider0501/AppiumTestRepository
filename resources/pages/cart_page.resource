*** Settings ***
Resource    resources/Resources.resource
Resource    resources/locators/cart_loc.resource

*** Keywords ***
Open Cart
    Click Button    ${CART_LOC}

Product Should Be In Cart
    Page Should Contain Text    ${TEST_PRODUCT_NAME}

Open Checkout
    Click Button    ${CHECKOUT_LOC}