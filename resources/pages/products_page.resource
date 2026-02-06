*** Settings ***
Resource   resources/keywords/common_page.resource
Resource    resources/locators/products_loc.resource

*** Keywords ***
Add Test Product To Cart
    Cart Should Be Empty
    ${idx}    Find Test Product Index
    Get Test Product Name    ${idx}
    Get Test Product Price    ${idx}
    Click Add To Cart Button    ${idx}
    Set Test Variable    ${NUMBER_OF_ITEMS_IN_CART}    1
    Cart Should Contain Number Of Elements    ${NUMBER_OF_ITEMS_IN_CART}

Find Test Product Index
    @{add_buttons}=    Get WebElements    ${ADD_TO_CART_LOC}
    ${count}=    Get Length    ${add_buttons}
    Should Be True    ${count} > 0    No products found on screen
    ${idx}=    Evaluate    random.randint(1, ${count})    modules=random
    RETURN    ${idx}

Get Product Details By Index
    [Arguments]    ${idx}    ${locator_type}
    @{elements}=    Get WebElements    ${locator_type}
    ${actual_count}=    Get Length    ${elements}
    Should Be True    ${actual_count} >= ${idx}    Only ${actual_count} elements, cannot access #${idx}
    ${value}=    Get Text    ${elements}[${idx-1}]
    RETURN  ${value}

Get Test Product Name
    [Arguments]    ${idx}
    ${name}  Get Product Details By Index    ${idx}    ${PRODUCTS_TITLES_LOC}
    Set Test Variable    ${TEST_PRODUCT_NAME}    ${name}

Get Test Product Price
    [Arguments]    ${idx}
    ${price}  Get Product Details By Index    ${idx}    ${PRODUCTS_PRICE_LOC}
    Set Test Variable    ${TEST_PRODUCT_PRICE}    ${price}

Click Add To Cart Button
    [Arguments]    ${idx}
    @{add_buttons}=    Get WebElements    ${ADD_TO_CART_LOC}
    Click Element    ${add_buttons}[${idx-1}]

Get Cart Item Count
    ${count}=    Get Text    ${CART_TEXT_LOC}
    Log    Cart contains ${count} items
    RETURN    ${count}

Cart Should Be Empty
    Page Should Not Contain Element    ${CART_TEXT_LOC}    ERROR

Cart Should Contain Number Of Elements
    [Arguments]    ${count}
    Element Text Should Be    ${CART_TEXT_LOC}    ${count}
