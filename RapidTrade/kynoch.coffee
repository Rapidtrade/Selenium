# mocha kynoch.coffee --compilers coffee:coffee-script/register --timeout 100000

selenium = require "selenium-webdriver"
chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect

before ->
  @timeout = 8000
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build()
  global.url = "http://localhost/git/rapidtrade"
  global.timeout = 20000
  global.waittime = 30000
  driver.getWindowHandle()
  driver.get url
  driver.findElement(id: 'exampleInputEmail1').sendKeys '00007001'
  driver.findElement(id: 'exampleInputPassword1').sendKeys 'PASSWORD1'
  driver.findElement(xpath: "//button[@type='submit']").click()
  driver.wait (->
    driver.isElementPresent(linkText: 'Admin')
  ), 100000, '\nFailed to load Welcome page.'
  driver.sleep 1000

describe "Check pricing, kynoch order screen when creating an order", ->
    it "Choose a customer & check for kynochCheckout", ->
        gocustomer('AFGRI DUNDEE')
        driver.findElement(xpath: "//button[span[text()='O']]").click()
        driver.isElementPresent(id: "OrderID")
        driver.findElement(id: "UserField01").sendKeys "Test Farm"
        driver.findElement(linkText: "Next").click()
        driver.wait (->
            driver.isElementPresent(id: "searchbox")
        ), 10000, "\nFailed to get to search page."

    it "Search for AMMUSAMIXBBUZI and be sure price & quickcapture are hidden", ->
        driver.findElement(id: "searchbox").sendKeys "AMMUSAMIXBBUZI"
        driver.findElement(id: "searchBtn").click()
        driver.wait (->
            driver.isElementPresent(id: "product0")
        ), 10000, "\nFailed to get to search page."

        driver.isElementPresent(id: "quickcapture0").then (isPresent) ->
            expect(isPresent).to.be.false
            return

        driver.isElementPresent(id: "price0").then (isPresent) ->
            expect(isPresent).to.be.false
            return

describe "Check Kynoch Product Detail for depot selection", ->
    it "Check that Kynoch's detail screen appears, select depot & add to cart", ->
        gocustomer('AFGRI DUNDEE')
        gosearch "AMMUSAMIXBBUZI", "AMMUSAMIXBBUZI"
        driver.findElement(id: "product0").click()
        driver.wait (->
            driver.isElementPresent(id: "depotsDd")
        ), 10000, "\nFailed to get to get Kynoch product detail screen."

        driver.findElement(id: "depotsDd").sendKeys "T"
        driver.wait (->
            driver.isElementPresent(id: "Quantity")
        ), 10000, "\nFailed to load jsonform."


    it "Check AMIPLUSGB for 92 depots", ->
        gosearch "AMIPLUSGB", "AMIPLUSGB"
        driver.findElement(id: "product0").click()
        driver.isElementPresent(xpath: "//select[@id='depotsDd']/option[91]")

describe "Check Kynoch Product Detail for pricing", ->
    it "Check list price does appear for Afgri Dundee / AMIPLUSGB", ->
        gocustomer('AFGRI DUNDEE')
        gosearch "AMIPLUSGB", "AMIPLUSGB"
        driver.findElement(id: "product0").click()
        driver.wait (->
            driver.isElementPresent(id: "depotsDd")
        ), 10000, "\nFailed to get to get Kynoch product detail screen."
        driver.findElement(id: "depotsDd").sendKeys "T"
        driver.sleep 500
        driver.findElement(id: "Nett").getAttribute("value").then (nett)->
            expect(nett).to.equal("6782")

    it "Check list price does NOT appear for Afgri Dundee / AMIPLUSGB", ->
        gocustomer('AFGRI OPERATIONS LTD(PONGOLA)')
        gosearch "AMIPLUSGB", "AMIPLUSGB"
        driver.findElement(id: "product0").click()
        driver.wait (->
            driver.isElementPresent(id: "depotsDd")
        ), 10000, "\nFailed to get to get Kynoch product detail screen."
        driver.findElement(id: "depotsDd").sendKeys "T"
        driver.sleep 500
        driver.findElement(id: "Nett").getAttribute("value").then (nett)->
            expect(nett).to.equal("")


# call this method to go into my territory and search for/select a customer
gocustomer = (custname) ->
    driver.get url + "#/myterritory"
    driver.sleep 500
    driver.findElement(xpath: "//a[div[text()='" + custname + "']]").click()
    driver.wait (->
        driver.isElementPresent(xpath: "//button[@class='selectactivitytype fa fa-plus']")
    ), timeout, "Could not find the customer "
    driver.sleep 500

# call this method to search for products
gosearch = (searchstr, waitfor) ->
    driver.get url + "#/products"
    driver.sleep 500
    driver.findElement(id: "searchbox").clear()
    driver.findElement(id: "searchbox").sendKeys searchstr
    driver.findElement(id: "searchBtn").click()
    driver.wait (->
        driver.isElementPresent(xpath: "//small[text()='" + waitfor + "']")
    ), waittime, "Could not find a " + waitfor
    driver.sleep 500
