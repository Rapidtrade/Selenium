# mocha test.coffee --compilers coffee:coffee-script/register --timeout 30000

selenium = require "selenium-webdriver"
chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect

before ->
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build()
  global.url = "http://localhost/git/rapidtrade"
  global.waittime = 30000
  global.pause = 1000
  driver.getWindowHandle()
  driver.get url
  driver.findElement(id: 'exampleInputEmail1').sendKeys 'TDD'
  driver.findElement(id: 'exampleInputPassword1').sendKeys 'PASSWORD'
  driver.findElement(xpath: "//button[@type='submit']").click()
  waitFor(linkText: 'Admin', 'Failed to load Welcome page')
  driver.sleep 1000

describe 'Test searching pricelist', ->
    it "Search for bikes", ->
        driver.get url + "#/myterritory"


# Wait for element
waitFor = (xpathelement, message) ->
  driver.wait (->
    driver.isElementPresent(xpathelement)
    ), 30000, "\n" + message
