# mocha kynoch.coffee --compilers coffee:coffee-script/register --timeout 30000

selenium = require "selenium-webdriver"
chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect

before ->
  @timeout = 8000
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build()
  global.url = "http://localhost/git/rapidtrade"
  global.timeout = 20000
  driver.getWindowHandle()
  driver.get url
  driver.findElement(id: 'exampleInputEmail1').sendKeys '00007001'
  driver.findElement(id: 'exampleInputPassword1').sendKeys 'PASSWORD'
  driver.findElement(xpath: "//button[@type='submit']").click()
  driver.wait (->
    driver.isElementPresent(linkText: 'Admin')
  ), 30000, '\nFailed to load Welcome page.'
  driver.sleep 1000

describe "Create order", ->
  it "Choose a customer & check for kynochCheckout", ->
    gocustomer('AFGRI DUNDEE')
    driver.findElement(xpath: "//button[span[text()='O']]").click()
    driver.isElementPresent(id: "OrderID")


# call this method to go into my territory and search for/select a customer
gocustomer = (custname) ->
    driver.get url + "#/myterritory"
    driver.sleep 500
    driver.findElement(xpath: "//a[div[text()='" + custname + "']]").click()
    driver.wait (->
        driver.isElementPresent(xpath: "//button[@class='selectactivitytype fa fa-plus']")
    ), timeout, "Could not find the customer "
    driver.sleep 500
