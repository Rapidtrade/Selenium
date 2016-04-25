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
  driver.findElement(id: 'exampleInputEmail1').sendKeys 'tdd@kynoch.co.za'
  driver.findElement(id: 'exampleInputPassword1').sendKeys 'PASSWORD'
  driver.findElement(xpath: "//button[@type='submit']").click()
  driver.wait (->
    driver.isElementPresent(linkText: 'Admin')
  ), 100000, '\nFailed to load Welcome page.'
  driver.sleep 1000

describe.only "Test 1: Check pricing, does appear for Afgri Dundee", ->
  it "Create new order and find product AMMUSAMIXBBUZI", ->
    gocustomer("AFGRI DUNDEE")
    goorder("farm 1", "A","A","A","order 1")
    gosearch("AMMUSAMIXBBUZI","AMMUSAMIXBBUZI")

  it "Check price & quickcapture are hidden on pricelist", ->
    driver.isElementPresent(id: "quickcapture0").then (isPresent) ->
      expect(isPresent).to.be.false
      return

    driver.isElementPresent(id: "price0").then (isPresent) ->
      expect(isPresent).to.be.false
      return

  it "Checking pricing shows in product detail  ", ->
    # Check price does show
    driver.findElement(id: "product0").click()
    waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
    driver.findElement(id: "depotsDd").sendKeys "("
    waitFor(id: "GrossTemp", "\nFailed to load jsonform.")
    driver.findElement(id: "GrossTemp").getAttribute("value").then (price)->
        expect(price).to.equal("7101")

  it "Check totals correct after changing price and entering rep discounts", ->
    driver.findElement(id: "Quantity").clear()
    driver.findElement(id: "Quantity").sendKeys "1"
    driver.findElement(id: "RepGross").clear()
    driver.findElement(id: "RepGross").sendKeys "6000"
    driver.findElement(id: "UserAmount01").clear()
    driver.findElement(id: "UserAmount01").sendKeys "1"
    driver.findElement(id: "UserAmount02").clear()
    driver.findElement(id: "UserAmount02").sendKeys "1"
    driver.findElement(id: "UserAmount03").clear()
    driver.findElement(id: "UserAmount03").sendKeys "1"
    driver.findElement(id: "UserFiedl01").sendKeys "r"
    driver.findElement(id: "UserAmount04").clear()
    driver.findElement(id: "UserAmount04").sendKeys "100"
    driver.findElement(id: "UserAmount05").clear()
    driver.findElement(id: "UserAmount05").sendKeys "100"
    driver.findElement(id: "TotalExcl").getAttribute("value").then (nett)->
        expect(nett).to.equal("6079")
    driver.findElement(id: "TotalIncl").getAttribute("value").then (nett)->
        expect(nett).to.equal("6930.06")
    driver.findElement(linkText: "OK").click()

  it "Check price in pricelist", ->
    waitFor(id: "productlist", "Could not find pricelist")
    driver.findElement(id: "totalexc").getText().then (nett)->
        expect(nett).to.equal("R6,079.00")

  it "Check shopping cart totals", ->
    driver.get url + "#/kynochCart"
    driver.sleep 1000
    driver.findElement(xpath: "//tr[1]/td[15]").getText().then (total)->
      expect(total).to.equal("R6,079.00")
    driver.findElement(xpath: "//tr[1]/td[14]").getText().then (total)->
      expect(total).to.equal("100.00")
    driver.findElement(xpath: "//tr[1]/td[13]").getText().then (total)->
      expect(total).to.equal("100.00")
    driver.findElement(xpath: "//tr[1]/td[12]").getText().then (total)->
      expect(total).to.equal("Road")
    driver.findElement(xpath: "//tr[1]/td[11]").getText().then (total)->
      expect(total).to.equal("1.00")
    driver.findElement(xpath: "//tr[1]/td[10]").getText().then (total)->
      expect(total).to.equal("1.00")
    driver.findElement(xpath: "//tr[1]/td[9]").getText().then (total)->
      expect(total).to.equal("1.00")
    driver.findElement(xpath: "//tr[1]/td[6]").getText().then (total)->
      expect(total).to.equal("1.000")
    driver.findElement(xpath: "//tr[1]/td[6]").getText().then (total)->
      expect(total).to.equal("1.000")
    driver.findElement(xpath: "//tr[1]/td[5]").getText().then (total)->
      expect(total).to.equal("R6,000.00")
    #Check totals
    driver.findElement(xpath: "//table[@class='table table-bordered']/tbody/tr[1]/td[2]").getText().then (total)->
      expect(total).to.equal("6,000.00")
    driver.findElement(xpath: "//table[@class='table table-bordered']/tbody/tr[2]/td[2]").getText().then (total)->
      expect(total).to.equal("121.00")
    driver.findElement(xpath: "//table[@class='table table-bordered']/tbody/tr[3]/td[2]").getText().then (total)->
      expect(total).to.equal("5,879.00")
    driver.findElement(xpath: "//table[@class='table table-bordered']/tbody/tr[4]/td[2]").getText().then (total)->
      expect(total).to.equal("100.00")
    driver.findElement(xpath: "//table[@class='table table-bordered']/tbody/tr[5]/td[2]").getText().then (total)->
      expect(total).to.equal("100.00")
    driver.findElement(xpath: "//table[@class='table table-bordered']/tbody/tr[6]/td[2]").getText().then (total)->
      expect(total).to.equal("6,079.00")
    driver.findElement(xpath: "//table[@class='table table-bordered']/tbody/tr[7]/td[2]").getText().then (total)->
      expect(total).to.equal("851.06")
    driver.findElement(xpath: "//table[@class='table table-bordered']/tbody/tr[9]/td[2]").getText().then (total)->
      expect(total).to.equal("6,930.06")



describe "Check Kynoch Product Detail for depot selection", ->
    it "Check that Kynoch's detail screen appears, select depot & add to cart", ->
        gocustomer('AFGRI DUNDEE')
        gosearch "AMMUSAMIXBBUZI", "AMMUSAMIXBBUZI"

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
    driver.findElement(id: "searchBox").sendKeys custname
    driver.findElement(id: "searchBtn").click()
    driver.findElement(xpath: "//a[div[text()='" + custname + "']]").click()
    waitFor(id: "AccountID", "Could not find the customer ")

# call this method to search for products
gosearch = (searchstr, waitfortext) ->
    driver.get url + "#/products"
    waitFor(id:"searchbox", "Cannot search for products")
    driver.findElement(id: "searchbox").clear()
    driver.findElement(id: "searchbox").sendKeys searchstr
    driver.findElement(id: "searchBtn").click()
    waitFor(xpath: "//small[text()='" + waitfortext + "']", "Could not find a " + waitfortext)

goaddtocart = (depotsDd) ->
  driver.findElement(id: "product0").click()
  waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
  driver.findElement(id: "depotsDd").sendKeys depotsDd
  waitFor(id: "Quantity", "\nFailed to load jsonform.")


# Create a new order
goorder = (farmname,shipto,payor,billto,payerordernum) ->
  driver.findElement(xpath: "//button[@class='companyPricelist0 btn-primary']").click()
  waitFor(id: "UserField01", "Could not start the Kynoch order form")
  driver.findElement(id: "UserField01").sendKeys farmname
  driver.findElement(id: "ShipTo").sendKeys shipto
  driver.findElement(id: "Payor").sendKeys payor
  driver.findElement(id: "BillTo").sendKeys billto
  driver.findElement(id: "PayorOrderNumb").sendKeys payerordernum
  driver.findElement(linkText: "Next").click()
  waitFor(id: "searchbox", "Could not start the Kynoch order")

# Wait for element
waitFor = (obj, message) ->
    driver.wait (->
      driver.isElementPresent(obj)
      ), 30000, "\n" + message
