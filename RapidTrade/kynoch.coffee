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

describe "Test 1: Check pricing, does appear for Afgri Dundee", ->
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
      godetails(1,7000,1,1,10,"R",100,0)
      driver.findElement(id: "TotalIncl").getAttribute("value").then (nett)->
          expect(nett).to.equal("7923")
      driver.findElement(linkText: "OK").click()
      waitFor(id: "product0","Issue adding to cart")

  it "Check shopping cart line items", ->
    driver.get url + "#/kynochCart"
    driver.sleep 1000
    # Check items
    driver.findElement(xpath: "//tr[1]/td[5]").getText().then (total)->
        expect(total).to.equal("R7,000.00")
    driver.findElement(xpath: "//tr[1]/td[9]").getText().then (total)->
        expect(total).to.equal("1.00")
    driver.findElement(xpath: "//tr[1]/td[10]").getText().then (total)->
        expect(total).to.equal("1.00")
    driver.findElement(xpath: "//tr[1]/td[11]").getText().then (total)->
        expect(total).to.equal("10.00")
    driver.findElement(xpath: "//tr[1]/td[13]").getText().then (total)->
        expect(total).to.equal("100.00")
    driver.findElement(xpath: "//tr[1]/td[15]").getText().then (total)->
        expect(total).to.equal("R6,950.00")

  it "Check shopping cart totals", ->
    driver.findElement(xpath: "//div/table/tbody/tr[3]/td[2]").getText().then (subtotal)->
        expect(subtotal).to.equal("6,850.00")
    driver.findElement(xpath: "//div/table/tbody/tr[4]/td[2]").getText().then (transport)->
        expect(transport).to.equal("100.00")
    driver.findElement(xpath: "//div/table/tbody/tr[7]/td[2]").getText().then (vat)->
        expect(vat).to.equal("973.00")
    driver.findElement(xpath: "//div/table/tbody/tr[9]/td[2]").getText().then (total)->
        expect(total).to.equal("7,923.00")

describe "Test 2: Check pricing, does not appear for ACUCAREIRA DE MOCAMBIQUE SAR", ->
    it "Create new order and find product AMMUSAMIXBBUZI", ->
        gocustomer("ACUCAREIRA DE MOCAMBIQUE SAR")
        goorder("farm 2", "A","A","A","order 2")
        gosearch("AMMUSAMIXBBUZI","AMMUSAMIXBBUZI")

    it "Check list price does NOT apprear", ->
        # Check price does show
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "("
        driver.findElement(id: "TotalExcl").getAttribute("value").then (nett)->
            expect(nett).to.equal("")

describe "Test 3: Get VAT from payor", ->
    it "Create new order and find product 10148FBU", ->
        gocustomer("HYGROTECH SA(PTY)LTD")
        goorder("farm 3", "H","H","H","order 3")
        gosearch("10148FBU","10148FBU")

    it "Check set price to 6600 and check INCL price is 7524", ->
        # Check price does show
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "(TP"
        godetails(1,6600,0,0,0,"C",0,0)
        driver.findElement(id: "TotalIncl").getAttribute("value").then (nett)->
            expect(nett).to.equal("7524")
        driver.findElement(linkText: "OK").click()
        waitFor(id: "product0","Issue adding to cart")

    it "Check shopping cart vat total is 924.00", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("924.00")

describe "Test 4: Get VAT from sold to", ->
    it "Create new order and find product 10148FBU", ->
        gocustomer("BOHLELA D M")
        goorder("farm 4", "B","C","C","order 4")
        gosearch("10148FBU","10148FBU")

    it "Check set price to 6600 and check INCL price is 7524", ->
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "(TP"
        godetails(5,6600,0,0,0,"C",0,0)
        driver.findElement(id: "TotalIncl").getAttribute("value").then (nett)->
            expect(nett).to.equal("33000")
        driver.findElement(linkText: "OK").click()
        waitFor(id: "product0","Issue adding to cart")

    it "Check shopping cart vat total is 0", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("0.00")

    it "Go back into product detail, change delivery to road and ensure VAT of R140 is charged", ->
        driver.findElement(xpath: "(//button[@class='btn btn-primary'])[1]").click()
        waitFor(id: "UserField05","Could not load kynoch details")
        driver.findElement(id: "UserField05").sendKeys "R"
        driver.findElement(id: "UserAmount04").clear()
        driver.findElement(id: "UserAmount04").sendKeys "200"
        driver.findElement(id: "TotalIncl").getAttribute("value").then (nett)->
            expect(nett).to.equal("34140")
        driver.findElement(linkText: "OK").click()
        driver.sleep 500
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("140.00")

describe "Test 5: Optimiser product", ->
    it "Create new order and find product 10148FBU", ->
        gocustomer("Tholo Holdings Pty (Ltd)")
        goorder("farm 5", "D","T","T","order 5")
        gosearch("SOYAOFF","SOYAOFF")

    it "Check for error if enter price less than list price", ->
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "(5230"
        godetails(0.75,3000,0,0,0,"C",0,0)
        driver.findElement(linkText: "OK").click()
        waitFor(xpath: "//div[@class='alert ng-scope top-right am-fade alert-danger']", "Did not get error message when ordering less than list")
        driver.sleep 4000

    it "Check total is 4018.5 with quantity of 0.75", ->
        godetails(0.75,47000,0,0,0,"C",0,0)
        driver.findElement(id: "TotalIncl").getAttribute("value").then (nett)->
            expect(nett).to.equal("40185")
        driver.findElement(linkText: "OK").click()
        waitFor(id: "product0","Issue adding to cart")

    it "Check shopping cart vat total is 0", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("4,935.00")

describe "Test 6: Full order with shipping/vat calculations", ->
    it "Create new order and find product 10148FBU", ->
        gocustomer("DIETANA TRADING & PROJECTS 30")
        goorder("farm 6", "D","T","T","order 6")

    it "Add first LAN28PB", ->
        gosearch("LAN28PB","LAN28PB")
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "(6"
        godetails(1,5928.50,0,0,0,"C",0,0)
        driver.findElement(linkText: "OK").click()

    it "Add 23222BBUZ2", ->
        gosearch("23222BBUZ2","23222BBUZ2")
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "(4"
        godetails(1,4831,0,0,0,"C",0,0)
        driver.findElement(linkText: "OK").click()

    it "Check shopping cart total is 0", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("12,265.83")

describe "Test 7: Collect order with non-vat customer", ->
    it "Create new order and find product 10148FBU", ->
        gocustomer("CATHRICH NO 70 CC")
        goorder("farm 7", "C","C","C","order 7")

    it "Add first AMIPLUSGB", ->
        gosearch("AMIPLUSGB","AMIPLUSGB")
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "("
        godetails(3,6738,7,0,0,"C",0,0)

    it "Check total INCL is 18,799.02", ->
        driver.findElement(id: "TotalIncl").getAttribute("value").then (totalincl)->
            expect(totalincl).to.equal("18799.02")
        driver.findElement(linkText: "OK").click()

    it "Check shopping cart total is 18,799.02", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[9]/td[2]/span").getText("value").then (total)->
            expect(total).to.equal("18,799.02")

describe "Test 8: Get 0% VAT from sold-to, but charge VAT on transport", ->
    it "Create new order and find product 10148FBU", ->
        gocustomer("BARWON CC")
        goorder("farm 8", "B","C","C","order 8")

    it "Add first AMMUSAMIXBBUZI", ->
        gosearch("AMMUSAMIXBBUZI","AMMUSAMIXBBUZI")
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "("
        godetails(8,7101,5,0,0,"R",199,0)

    it "Check product detail total INCL is 18,799.02", ->
        driver.findElement(id: "TotalIncl").getAttribute("value").then (totalincl)->
            expect(totalincl).to.equal("55782.48")
        driver.findElement(linkText: "OK").click()
        driver.sleep 500

    it "Check shopping cart total is 18,799.02", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("222.88")
        driver.findElement(xpath: "//table/tbody/tr[9]/td[2]/span").getText("value").then (total)->
            expect(total).to.equal("55,782.48")

describe.only "Test 9: Mixture of discount/transport costs on 2 items", ->
    it "Create new order", ->
        gocustomer("AFGRI DUNDEE")
        goorder("farm 9", "A","A","A","order 9")

    it "Add 1st AMIPLUSGB with 5% spec discount", ->
        gosearch("AMIPLUSGB","AMIPLUSGB")
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "("
        godetails(1,6822.90,5,0,0,"c",0,0)
        driver.findElement(linkText: "OK").click()
        driver.sleep 500

    it "Add 2nd AMIPLUSBSUS with R199 transport", ->
        gosearch("AMIPLUSBSUS","AMIPLUSBSUS")
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "("
        godetails(1,6113.68,0,0,0,"r",199,0)
        driver.findElement(linkText: "OK").click()
        driver.sleep 500

    it "Check shopping cart total is 14,585.66", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("1,791.22")
        driver.findElement(xpath: "//table/tbody/tr[9]/td[2]/span").getText("value").then (total)->
            expect(total).to.equal("14,585.66")

describe "Test 10: Optimiser/non-optimiser products", ->
    it "Create new order", ->
        gocustomer("AFGRI DUNDEE")
        goorder("farm 10", "A","A","A","order 10")

    it "Add 1st AMIPLUSGB non-optimiser", ->
        gosearch("AMIPLUSGB","AMIPLUSGB")
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "("
        godetails(1,6800,0,0,0,"c",0,0)
        driver.findElement(linkText: "OK").click()
        driver.sleep 500

    it "Add 2nd SOYAOFF optimiser", ->
        gosearch("SOYAOFF","SOYAOFF")
        driver.findElement(id: "product0").click()
        waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
        driver.findElement(id: "depotsDd").sendKeys "("
        godetails(1,35000,0,0,0,"c",0,0)
        driver.findElement(linkText: "OK").click()
        driver.sleep 500

    it "Check shopping cart total is 47,652.00", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("5,852.00")
        driver.findElement(xpath: "//table/tbody/tr[9]/td[2]/span").getText("value").then (total)->
            expect(total).to.equal("47,652.00")

describe.only "Test 11: Big Order", ->
    it "Create new order", ->
        gocustomer("BOHLELA D M")
        goorder("farm 11", "b","c","c","order 11")

    it "Add 1st AMIPLUSGB ", ->
        goaddproducttocart("AMIPLUSGB","(",3,6700,0,0,0,"c",0,0,"20100")

    it "Add 2nd AMIPLUSBSUS optimiser, check for total R6100", ->
        goaddproducttocart("AMIPLUSBSUS","(",1,6100,0,0,0,"c",0,0,"6100")

    it "Add 3rd AMIPLUSBBUS", ->
        goaddproducttocart("AMIPLUSBBUS","(",2,6150,0,0,0,"r",200,0,"12756")

    it "Add 4th AMIPLUSBBUS, check total is 6411 ", ->
        goaddproducttocart("AMIPLUSGT","(",1,6240,0,0,0,"r",150,0,"6411")

    it "Add 5th AMMUSAMIXBBUZI, check total is 28623,44 ", ->
        goaddproducttocart("AMMUSAMIXBBUZI","(",4,7100,0,0,0,"c",0,49,"28623,44")

    it "Add 6th 10148FBU, check total is 6560", ->
        goaddproducttocart("10148FBU","(",1,6560,0,0,0,"r",150,0,"6560")

    it "Add 7th 10243FFU, check total is 6560", ->
        goaddproducttocart("10243FFU","(",1,9500,0,0,0,"r",199,35,"9766,76")

    it "Add 8th 31847BFNZIS6, check total is 28494,76", ->
        goaddproducttocart("31847BFNZIS6","(",2,14000,0,0,0,"r",150,67,"28494,76")

    it "Add 9th ACHILLESFFU, check total is 22121,28", ->
        goaddproducttocart("ACHILLESFFU","(",3,7050,0,0,0,"r",249,35,"22121,28")

    it "Check shopping cart total is 47,652.00", ->
        driver.get url + "#/kynochCart"
        driver.sleep 1000
        driver.findElement(xpath: "//table/tbody/tr[7]/td[2]/span").getText("value").then (vat)->
            expect(vat).to.equal("317.24")
        driver.findElement(xpath: "//table/tbody/tr[9]/td[2]/span").getText("value").then (total)->
            expect(total).to.equal("140,933.24")

###
describe "Check Kynoch Product Detail for depot selection", ->
    it "Check that Kynoch's detail screen appears, select depot & add to cart", ->
        gocustomer('AFGRI DUNDEE')
        gosearch "AMMUSAMIXBBUZI", "AMMUSAMIXBBUZI"

    it "Check AMIPLUSGB for 92 depots", ->
        gosearch "AMIPLUSGB", "AMIPLUSGB"
        driver.findElement(id: "product0").click()
        driver.isElementPresent(xpath: "//select[@id='depotsDd']/option[91]")
###

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

# Enter new product
godetails = (Quantity, RepGross, UserAmount01, UserAmount02, UserAmount03, UserField05, UserAmount04, UserAmount05) ->
    waitFor(id: "Quantity","Could not find product or depot")
    driver.findElement(id: "Quantity").clear()
    driver.findElement(id: "Quantity").sendKeys Quantity
    driver.findElement(id: "RepGross").clear()
    driver.findElement(id: "RepGross").sendKeys RepGross
    driver.findElement(id: "UserAmount01").clear()
    driver.findElement(id: "UserAmount01").sendKeys UserAmount01
    driver.findElement(id: "UserAmount02").clear()
    driver.findElement(id: "UserAmount02").sendKeys UserAmount02
    driver.findElement(id: "UserAmount03").clear()
    driver.findElement(id: "UserAmount03").sendKeys UserAmount03
    driver.findElement(id: "UserField05").sendKeys UserField05
    driver.findElement(id: "UserAmount04").clear()
    driver.findElement(id: "UserAmount04").sendKeys UserAmount04
    driver.findElement(id: "UserAmount05").clear()
    driver.findElement(id: "UserAmount05").sendKeys UserAmount05

# Add product to shopping cart & check for valud totalIncl
goaddproducttocart = (ProductID, Depot, Quantity, RepGross, SpecDisc, CashDisc, RUOMDisc, DeliveryMode, Transport, Handling, TotalIncl) ->
    gosearch("AMIPLUSGB","AMIPLUSGB")
    driver.findElement(id: "product0").click()
    waitFor(id: "depotsDd", "\nFailed to get to get Kynoch product detail screen.")
    driver.findElement(id: "depotsDd").sendKeys Depot
    godetails(Quantity, RepGross, SpecDisc, CashDisc, RUOMDisc, DeliveryMode, Transport, Handling)
    driver.findElement(id: "TotalIncl").getAttribute("value").then (totalincl)->
        expect(totalincl).to.equal(TotalIncl)
    driver.findElement(linkText: "OK").click()
    driver.sleep 500

# Wait for element
waitFor = (obj, message) ->
    driver.wait (->
      driver.isElementPresent(obj)
      ), 30000, "\n" + message
