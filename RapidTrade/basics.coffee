# mocha basics.coffee --compilers coffee:coffee-script/register --timeout 30000

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
  driver.wait (->
    driver.isElementPresent(linkText: 'Admin')
  ), global.timeout, '\nFailed to load Welcome page.'
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
        driver.sleep pause
        gopricelist "TDD Customer 2"
        gosearch "bi", "BIKE1"
        waitFor(xpath: "//small[text()='BIKE2']", "Could not find a BIKE")

    it "Add BIKE1 to cart using plus button", ->
        gosearch "mou bi", "BIKE1"
        driver.findElement(id: "plusBIKE1").click()
        driver.sleep 200
        driver.findElement(id: "quantityBIKE1").getAttribute("value").then (qty)->
            expect(qty).to.equal("1")
        driver.findElement(id: "cartcount").getText().then (carttext) ->
            expect(carttext).to.have.string("(1)")
        driver.findElement(id: "totalexc").getText().then (carttotal) ->
            expect(carttotal).to.equal("R7,000.00")

    it "Add BIKE2 to cart using input box", ->
        driver.sleep 200
        driver.findElement(id: "quantityBIKE2").sendKeys "1"
        driver.sleep 500
        driver.findElement(id: "cartcount").getText().then (carttext) ->
            expect(carttext).to.have.string("(2)")
        driver.findElement(id: "totalexc").getText().then (carttotal) ->
            expect(carttotal).to.equal("R17,000.00")

describe 'Check Shopping Cart', ->
    it "Search for bikes", ->
        driver.sleep pause
        gopricelist "TDD Customer 3"
        gosearch "bi", "BIKE1"

    it "Add 2 bikes to cart", ->
        driver.findElement(id: "quantityBIKE1").clear()
        driver.findElement(id: "quantityBIKE1").sendKeys "1"
        driver.findElement(id: "quantityBIKE2").clear()
        driver.findElement(id: "quantityBIKE2").sendKeys "2"
        driver.findElement(id: "searchBtn").click()
        waitFor(xpath: "//small[text()='BIKE2']", "Could not find a BIKE")

    it "Change a quantity", ->
        driver.get url + "#/products/cart"
        waitFor(xpath:"//input[@id='cartQtyBIKE1']", "Could not find a deleteBIKE2 button")
        driver.findElement(id: "cartQtyBIKE1").clear()
        driver.findElement(id: "cartQtyBIKE1").sendKeys "10"
        #Selenium bug: must go back to pricelist to check grand total :-(
        driver.findElement(linkText: "Search").click()
        driver.findElement(id: "searchBtn").click()
        driver.sleep 500
        driver.findElement(id: "totalexc").getText().then (carttotal) ->
            expect(carttotal).to.equal("R100,000.00")
    ###
    it "Delete BIKE2 from cart", ->
        driver.findElement(xpath: "//a[contains(.,'Shopping Cart')]").click()
        waitFor "//button[@id='deleteBIKE2']", "Could not find a deleteBIKE2 button"
        driver.findElement(id: "deleteBIKE2").click()
        driver.isElementPresent(id: "deleteBIKE2").then (isPresent) ->
            expect(isPresent).to.be.false
    ###

describe 'Check Product Details', ->
    it "Search for BIKE1", ->
        driver.sleep pause
        gopricelist "TDD Customer 1"
        gosearch "bi", "BIKE1"
        driver.findElement(xpath: "//a[div/div/div/strong/small[text()='BIKE1']]").click()
        driver.sleep 1000

    it "Check Product Details and setting Display Fields", ->
        driver.findElement(id: "settingBtn").click()
        #unclick all display fields
        deselectDF 2
        deselectDF 3
        deselectDF 4
        deselectDF 5
        deselectDF 6
        deselectDF 7
        deselectDF 8
        deselectDF 9
        deselectDF 10
        deselectDF 11
        deselectDF 12
        #set display fields we want displayed
        selectDF "ProductID", "1", "Code"
        selectDF "Description", "2", ""
        selectDF "CategoryName", "3", ""
        selectDF "Nett", "4", ""
        driver.findElement(id: "saveBtn").click()
        waitFor(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']","Failed to save display fields")
        waitFor(xpath: "//b[text()='Code:']","Failed to load displayfields label correctly")

    it "Check entering quantity and back to pricelist to check for total is R24000", ->
        driver.findElement(id: "quantity").clear()
        driver.findElement(id: "quantity").sendKeys "4"
        driver.findElement(id: "okbtn").click()
        driver.sleep 500
        driver.findElement(id: "quantityBIKE1").getAttribute("value").then (qty)->
            expect(qty).to.equal("4")
        driver.findElement(id: "totalexc").getText().then (carttotal) ->
            expect(carttotal).to.equal("R24,000.00")

describe 'Check expand categories', ->
    it "Search for BIKE1 and click expand button", ->
        driver.sleep pause
        gopricelist "TDD Customer 2"
        gosearch "bike1", "BIKE1"
        driver.findElement(id: "expandcatButton").click()
        driver.wait (->
            driver.isElementPresent(id: "cat0")
            ), waittime, "Mountain bike category did not appear"
        driver.isElementPresent(xpath: "//div[text()='Mountain Bikes']")

    it "Click mountain bikes and check BIKE2 appears", ->
        driver.findElement(id: "cat0").click()
        driver.wait (->
            driver.isElementPresent(xpath: "//small[text()='BIKE2']")
        ), waittime, "Expanding categories did not find BIKE2"

describe 'Create Online Orders', ->
    it "Add items to the cart", ->
        driver.sleep pause
        gopricelist "TDD Customer 2"
        gosearch "bike", "BIKE1"
        driver.findElement(id: "quantityBIKE1").clear()
        driver.findElement(id: "quantityBIKE1").sendKeys "2"
        driver.findElement(xpath: "//a[contains(.,'Shopping Cart')]").click()
        driver.wait (->
            driver.isElementPresent(id: "deleteBIKE1")
            ), waittime, "could not load basket"

    it "Set display fields for order headers", ->
        driver.findElement(linkText: "Checkout").click()
        driver.sleep 1000
        driver.findElement(id: "settingBtn").click()
        deselectDF 2
        deselectDF 3
        deselectDF 4
        deselectDF 5
        deselectDF 6
        deselectDF 7
        deselectDF 8
        deselectDF 9
        deselectDF 10
        deselectDF 11
        deselectDF 12
        selectDF "Reference", "1", "PO Number"
        selectDF "RequiredByDate", "2", ""
        driver.findElement(id: "typeRequiredByDate").sendKeys "d"
        driver.findElement(id: "saveBtn").click()
        waitFor(xpath: "//label[text()='PO Number']","Failed to set displayfields label")

    it "Wait for alert to disappear and create order online", ->
        driver.sleep 4000
        driver.findElement(id: "Reference").sendKeys "my reference"
        driver.findElement(linkText: "Save").click()
        waitFor(xpath: "//div[@class='alert alert-success ng-binding ng-scope']","Did not get order success")

describe 'Create Offline Orders', ->
    it "Add items to the cart", ->
        driver.sleep pause
        gopricelist "TDD Customer 2"
        gosearch "bike", "BIKE1"
        driver.findElement(id: "quantityBIKE1").clear()
        driver.findElement(id: "quantityBIKE1").sendKeys "2"
        driver.findElement(xpath: "//a[contains(.,'Shopping Cart')]").click()
        driver.wait (->
            driver.isElementPresent(id: "deleteBIKE1")
            ), waittime, "could not load basket"

    it "Enter order header", ->
        driver.findElement(linkText: "Checkout").click()
        driver.sleep 1000
        driver.findElement(id: "Reference").sendKeys "my reference"
        driver.findElement(id: "offlineBtn").click()
        waitFor(xpath: "//div[@class='alert alert-warning ng-binding']", "Offline warning did not appear")
        driver.findElement(linkText: "Save").click()
        waitFor(xpath: "//div[contains(.,'saved offline')]", "Did not get success message")

    it "Sync to send order", ->
        driver.get url + "#/sync"
        driver.sleep 1000
        driver.findElement(id: "exampleInputPassword1").sendKeys "PASSWORD"
        driver.findElement(linkText: "Synchronize").click()
        waitFor(xpath: "//td[contains(.,'Sending Orders(1) --OK')]", "Order was not sent during the sync")
        waitFor(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']","Sync did not finish")

describe 'Give rep price against customer 4', ->
    it "Add bike1 to the cart and change price to R5000.00", ->
        driver.sleep pause
        gopricelist "TDD Customer 4"
        gosearch "bike", "BIKE1"
        driver.findElement(xpath: "//a[div/div/div/strong/small[text()='BIKE1']]").click()
        driver.sleep 2000
        driver.findElement(id: "repnett").clear()
        driver.findElement(id: "repnett").sendKeys "5000"
        driver.findElement(id: "quantity").clear()
        driver.findElement(id: "quantity").sendKeys "1"
        driver.findElement(id: "okbtn").click()
        waitFor(xpath: "//small[text()='BIKE1']", "Could not find BIKE1")

    it "Check pricelist price is R5000 in pricelist", ->
        driver.findElement(id: "price0").getText().then (price) ->
            expect(price).to.equal("R5,000.00")

    it "Check grandtotal is R5000 in pricelist", ->
        driver.findElement(id: "totalexc").getText().then (carttotal) ->
            expect(carttotal).to.equal("R5,000.00")

describe 'Give rep discount on TDD customer 4: BIKE1', ->
    it "Open customer 4, empty basket and click on BIKE1", ->
        driver.sleep pause
        gopricelist "TDD Customer 4"
        gosearch "bike", "BIKE1"
        goclearcart()
        driver.findElement(xpath: "//a[div/div/div/strong/small[text()='BIKE1']]").click()
        driver.sleep 1000

    it "Add bike1 to the cart and give 10% rep discount", ->
        driver.findElement(id: "repdiscount").clear()
        driver.findElement(id: "repdiscount").sendKeys "10"
        driver.findElement(id: "quantity").clear()
        driver.findElement(id: "quantity").sendKeys "1"
        driver.findElement(id: "okbtn").click()
        waitFor(xpath: "//small[text()='BIKE1']", "Could not find BIKE2")

    it "Check pricelist price is R7200 in pricelist", ->
        driver.findElement(id: "price0").getText().then (price) ->
            expect(price).to.equal("R7,200.00")

    it "Check grandtotal is R7200 in pricelist", ->
        driver.findElement(id: "totalexc").getText().then (carttotal) ->
            expect(carttotal).to.equal("R7,200.00")

    it "Now clear the discount to see if pricing returns to R8000", ->
        driver.findElement(xpath: "//a[div/div/div/strong/small[text()='BIKE1']]").click()
        driver.findElement(id: "repdiscount").clear()
        driver.findElement(id: "okbtn").click()
        driver.sleep 1000

    it "Check pricelist price is R8000 in pricelist", ->
        driver.findElement(id: "price0").getText().then (price) ->
            expect(price).to.equal("R8,000.00")

    it "Check grandtotal is R8000 in pricelist", ->
        driver.findElement(id: "totalexc").getText().then (carttotal) ->
            expect(carttotal).to.equal("R8,000.00")

describe.only 'Create order and check repnett in order history', ->
    it "Open customer 2 and search for bikes", ->
        driver.sleep pause
        gopricelist "TDD Customer 2"
        gosearch "bike", "BIKE1"
        goclearcart()
        driver.findElement(xpath: "//a[div/div/div/strong/small[text()='BIKE2']]").click()
        driver.sleep 1000

    it "Add bike1 to the cart and give 10% rep discount", ->
        driver.findElement(id: "repdiscount").clear()
        driver.findElement(id: "repdiscount").sendKeys "10"
        driver.findElement(id: "quantity").clear()
        driver.findElement(id: "quantity").sendKeys "1"
        driver.findElement(id: "okbtn").click()
        waitFor(xpath: "//small[text()='BIKE2']","Could not find BIKE1")

    it "Checkout", ->
        driver.findElement(linkText: "Checkout").click()
        driver.sleep 1000
        d = new Date
        global.ref = d.getDate() + d.getMonth() + d.getHours() + d.getMinutes() + d.getSeconds()
        driver.findElement(id: "Reference").sendKeys "test repnett " + global.ref
        driver.findElement(id: "onlineBtn").click()
        driver.findElement(linkText: "Save").click()
        waitFor(xpath: "(//a[contains(.,'customer det')])[1]","Could not create order")

    it "Check in order history that price is R10800", ->
        driver.sleep 400
        driver.findElement(xpath: "//a[contains(.,'customer det')]").click()
        driver.sleep 500
        driver.findElement(xpath: "//a[contains(.,'History')]").click()
        driver.findElement(xpath: "//a[contains(.,'Orders')]").click()
        waitFor(xpath: "//a[div/div[contains(.,'" + global.ref + "')]]","Could not find order in order history")
        driver.findElement(xpath: "//a[div/div[contains(.,'" + global.ref + "')]]").click()
        waitFor(xpath: "//a/div[@id='nettprice']","Could not find our price")
        driver.findElement(xpath: "//a/div[@id='nettprice']").getText().then (price) ->
            expect(price).to.equal("R9,000.00")


#####################################################################################################
# call this function to unselect a displayfield
deselectDF = (cnt) ->
    driver.findElement(xpath: "//tr[" + cnt + "]/td[4]/input").getAttribute("checked").then (val) ->
        if val == "true"
            driver.findElement(xpath: "//tr[" + cnt + "]/td[4]/input").click()

# call this function to select a displayfield
selectDF = (field, order, label) ->
    driver.findElement(id: "visible" + field).click()
    driver.findElement(id: "sort" + field).click()
    driver.findElement(id: "sort" + field).clear()
    driver.findElement(id: "sort" + field).sendKeys order
    if label != ""
        driver.findElement(id: "label" + field).clear()
        driver.findElement(id: "label" + field).sendKeys label

# call this method to search for products
gosearch = (searchstr, waitfor) ->
    driver.findElement(id: "searchbox").clear()
    driver.findElement(id: "searchbox").sendKeys searchstr
    driver.findElement(id: "searchBtn").click()
    driver.wait (->
        driver.isElementPresent(xpath: "//small[text()='" + waitfor + "']")
    ), waittime, "Could not find a " + waitfor
    driver.sleep 500

# Wait for element
waitFor = (xpathelement, message) ->
    driver.wait (->
      driver.isElementPresent(xpathelement)
      ), 30000, "\n" + message


# call this method to go into my territory and search for/select a customer
gopricelist = (custname) ->
    driver.get url + "#/myterritory"
    driver.sleep 500
    driver.findElement(xpath: "//a[div[text()='" + custname + "']]").click()
    driver.sleep 500
    driver.findElement(xpath: "//button[span[text()='O']]").click()
    driver.wait (->
        driver.isElementPresent(id: "searchbox")
    ), waittime, "Could not find the searchbox "
    driver.sleep 500

# Clear the basket items
goclearcart = () ->
    driver.findElement(id: "quantityBIKE1").clear()
    driver.findElement(id: "quantityBIKE2").clear()
    driver.findElement(id: "quantityBIKE3").clear()
    driver.findElement(id: "quantityBIKE4").clear()
