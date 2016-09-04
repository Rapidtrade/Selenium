# mocha pioneer.coffee --compilers coffee:coffee-script/register --timeout 60000

selenium = require "selenium-webdriver"
chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect

before ->
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build()
  global.url = "http://localhost/git/rapidtrade"
  global.waittime = 60000
  global.pause = 1000
  driver.getWindowHandle()
  driver.get url
  driver.findElement(id: 'exampleInputEmail1').sendKeys 'PIONEER'
  driver.findElement(id: 'exampleInputPassword1').sendKeys 'PASSWORD'
  driver.findElement(xpath: "//button[@type='submit']").click()
  waitFor(linkText: 'Admin', 'Failed to load Welcome page')
  driver.sleep 1000

describe 'Test stock controller', ->
    it "Create test deliveries for today for routes TDD1 and TDD2", ->
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_clear&supplierid=%27pioneer%27&routeid=%27TDD1%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162291608025984%27&Reference=%27INV211%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162362309593149%27&Reference=%27INV211%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD2%27&AccountID=%27162352211253236%27&Reference=%27INV212%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")

    it "Choose route WC1", ->
        # add tests here to log in as stock controller, go to #/replenish and choose the WC1 route
        # assert that 2 deliveries are displayed

    it "Create replenishment", ->
        # now underdeliver the first row by 5, then overdeliver the 2nd row by 5, then create the replenishment

    it "Create another delivery for TDD1", ->
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162291608025984%27&Reference=%27INV211%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")

    it "Check replenish proposal has increased delivery quantities", ->
        # check that delivery quantities have increased due to the new delivery
        # save the replenishment

describe 'Test driver GRV', ->
    it "Create test deliveries, then a replenishment for today for routes TDD1", ->
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_clear&supplierid=%27pioneer%27&routeid=%27TDD1%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162291608025984%27&Reference=%27INV211%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162352211253236%27&Reference=%27INV212%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_create&supplierid=%27pioneer%27&routeid=%27TDD1%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")

    it "Driver selects route", ->
        # Driver must go into delivery screen, should have one route on screen and should click on it.
        # Assert that 2 routes dont show on screen

    it "Driver accepts GRV and Load", ->
        # click on yellow icon and the GRV view should appear
        # assert that the quantities are correct
        # driver should click the accept button
        # assert that the green truck now appears as the icon for the route

    it "Driver views the deliveries", ->
        # click on the route to see the deliveries
        # assert that we have 2 deliveries on screen
        # assert that trucks are green

    it "Check stock controller can no longer create replenishments for those deliverues"
        # go back to stock controller screen
        # choose TDD1 route
        # assert nothing is proposed for replenishment values have come through

describe.only 'Test driver POD', ->
    it "Create test deliveries, replenishment & GRV for today for routes TDD1", ->
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_clear&supplierid=%27PIONEER%27&routeid=%27TDD1%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27PIONEER%27&routeid=%27TDD1%27&AccountID=%27162291608025984%27&Reference=%27INV211%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27PIONEER%27&routeid=%27TDD1%27&AccountID=%27162352211253236%27&Reference=%27INV212%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_create&supplierid=%27PIONEER%27&routeid=%27TDD1%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")
        driver.get "http://api.rapidtrade.biz/rest/Get?method=tdd_grv_create&supplierid=%27PIONEER%27&routeid=%27TDD1%27&DriverID=%27PDRIVER1%27"
        waitFor(xpath: "/html/body/pre","Did not get a result")

    it "Sync so that our days stock comes down", ->
        # perform sync and ensure usp_vanstock_sync4 routeNumbers

    it "Go to my deliveries", ->
        # go to my deliveries
        # choose today and click submit
        # should have one route and assert has green trucks
        # assert 2 deliveries

    it "Deliver INV211", ->
        # Click on INV211
        #





# Wait for element
waitFor = (xpathelement, message) ->
  driver.wait (->
    driver.isElementPresent(xpathelement)
    ), waittime, "\n" + message
