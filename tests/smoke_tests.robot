*** Settings ***
Resource    resources/Resources.resource
Suite Setup     Setup Test Environment
Suite Teardown  Close Application

*** Test Cases ***
Login With Standard Credentials
    [Documentation]    This is a smoke test for placing an order
    [Tags]  SMOKE_TEST

    Login With Standard Credentials
    Find Test Product Index
    Add Test Product To Cart
    Open Cart
    Product Should Be In Cart
    Open Checkout
    Fill Checkout Data
    Continue Checkout
    Verify Checkout Data
    Scroll To Finish And Click
    Placed Order Confirmed
