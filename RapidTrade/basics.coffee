# mocha basics.coffee --compilers coffee:coffee-script/register --timeout 30000

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
  driver.findElement(id: 'exampleInputEmail1').sendKeys 'TDD'
  driver.findElement(id: 'exampleInputPassword1').sendKeys 'PASSWORD'
  driver.findElement(xpath: "//button[@type='submit']").click()
  driver.wait (->
    driver.isElementPresent(linkText: 'Admin')
  ), 50000, '\nFailed to load Welcome page.'
  driver.sleep 1000

###
after ->
  driver.quit()
###
###
describe 'Reset TDD Rapidtargets data', ->
  it "Reset TDD supplier", ->
    driver.get url + "/#/test/"
    driver.sleep 500
    driver.findElement(id: "resetBtn").click()
    driver.wait ( ->
      driver.isElementPresent(id: 'successmsg')
    ), 10000, '\nFailed to reset data.'
###
describe 'Test searching pricelist', ->
  it "Search for bikes", ->
    driver.get url + "#/myterritory"
    driver.findElement(xpath: "//a[div[text()='TDD Customer 2']]").click()
    driver.findElement(id: "searchbox").sendKeys "bi"
    driver.findElement(xpath: "//button[text()='Search']").click()
    driver.wait (->
        driver.isElementPresent(xpath: "//small[text()='BIKE2']")
    ), 30000, "Could not find a BIKE"
