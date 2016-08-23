# pwd
# cd RapidDelivery
# pwd
# mocha rcl.coffee --compilers coffee:coffee-script/register --timeout 60000
selenium = require "selenium-webdriver"
chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect
before ->
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build()
  global.url = "http://knight.rapidtrade.mobi"
  global.waittime = 60000
  global.pause = 1000
  driver.getWindowHandle()
  resetData()
  driver.get url
  driver.findElement(id: 'exampleInputEmail1').sendKeys 'RCLQA'
  driver.findElement(id: 'exampleInputPassword1').sendKeys 'password'
  driver.findElement(xpath: "//button[@type='submit']").click()
  waitFor(linkText: 'Admin', 'Failed to load Welcome page')
  driver.sleep 1000

describe 'Create POD', ->
    it "Select 21 July", ->
        driver.get url + "#/pod"
        waitFor(xpath:"//input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']","input box not found")
        driver.findElement(xpath:"//input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']").sendKeys "July 21, 2016"
        driver.findElement(xpath:"//button[@class='btn btn-primary']").click()
        waitFor(xpath:"//input[@class='//a[div/div/div[text()='QHUBEKANIS ']]")
        driver.findElement(xpath:"//input[@class='//a[div/div/div[text()='QHUBEKANIS ']]").click()



resetData = () ->
  driver.get("http://api.rapidtrade.biz/rest/Get?method=orders_removereference&supplierid=RCLQA&orderid=8012928214")
  waitFor(xpath: "//pre")

# Wait for element
waitFor = (xpathelement, message) ->
  driver.wait (->
    driver.isElementPresent(xpathelement)
  ), 80000, "\n" + message
