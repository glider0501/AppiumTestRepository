*** Settings ***
Resource    resources/Resources.resource
Suite Setup     Checkout Validation Prerequisites
Suite Teardown  Close Application

*** Test Cases ***
Login With Standard Credentials
    [Documentation]    This is a test verifying required fields in checkout page
    [Tags]  CHECKOUT_INFORMATION  NEGATIVE_TESTS

    Verify Checkout Required Fields
    
*** Keywords ***
Checkout Validation Prerequisites
    Setup Test Environment
    Login With Standard Credentials
    Find Test Product Index
    Add Test Product To Cart
    Open Cart
    Product Should Be In Cart
    Open Checkout