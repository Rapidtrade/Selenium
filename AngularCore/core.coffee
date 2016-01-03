# mocha core.coffee --compilers coffee:coffee-script/register --timeout 30000

selenium = require "selenium-webdriver"
chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect


before ->
  @timeout = 8000
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build()
  global.url = "http://localhost/ws/angularcore"
  driver.getWindowHandle()
  driver.get url
  driver.findElement(id: 'exampleInputEmail1').sendKeys 'TDD'
  driver.findElement(id: 'exampleInputPassword1').sendKeys 'PASSWORD'
  driver.findElement(xpath: "//button[@type='submit']").click()
  driver.wait (->
    driver.isElementPresent(linkText: 'Admin')
  ), 30000, '\nFailed to load Welcome page.'
  driver.sleep 1000


after ->
  driver.quit()


describe 'Reset TDD data', ->
  it "Reset TDD supplier", ->
    driver.get url + "/#/test/"
    driver.sleep 500
    driver.findElement(id: "resetBtn").click()
    driver.wait ( ->
      driver.isElementPresent(id: 'successmsg')
    ), 10000, '\nFailed to reset data.'

describe 'Admin Tests 1', ->
  it "Create user", ->
    driver.get url + "/#/users/"
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "UserID").sendKeys "TDDMANAGER"
    driver.findElement(id: "Name").sendKeys "TDD manager"
    driver.findElement(id: "Password").sendKeys "PASSWORD"
    driver.findElement(xpath: "//div[@class='checkbox'][2]/label/input").click()
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert alert-success ng-binding ng-scope']")
    ), 5000, "\nFailed to create user"

  it "Create options", ->
    driver.get url + "/#/options/"
    driver.findElement(linkText: "New Option").click()
    driver.findElement(id: "Name").sendKeys "CurrencyFormat"
    driver.findElement(id: "Group").sendKeys "Online"
    driver.findElement(id: "Value").sendKeys "NZD"
    driver.findElement(id: "Type").sendKeys "T"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert alert-success ng-binding ng-scope']")
    ), 10000, "\nFailed to create option"

  it "Create User Exit", ->
    driver.get url + "/#/userexit/"
    driver.findElement(linkText: "New").click()
    driver.sleep 2000
    driver.findElement(id: "UserExitID").sendKeys "A"
    driver.sleep 1000
    driver.findElement(id: "Code").sendKeys "alert 'hello';"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert alert-success ng-binding ng-scope']")
    ), 5000, "\nFailed to save user exit"


  it "Create tree", ->
    driver.get url + "/#/tree/"
    driver.findElement(linkText: "New Tree").click()
    driver.findElement(id: "TreeID").sendKeys "PL"
    driver.findElement(id: "Description").sendKeys "Pricelist"
    driver.findElement(id: "ParentTreeID").sendKeys "mainmenu"
    driver.findElement(id: "Tags").sendKeys ""
    driver.findElement(id: "Tips").sendKeys "#/pricelist"
    driver.findElement(id: "SortOrder").sendKeys "1"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//a[@class='list-group-item ng-scope']")
    ), 20000, "\nFailed to save tree"
    driver.sleep 3000
    driver.findElement(xpath: "//div[@class='col-xs-3 ng-binding'][1]").getText().then (treeID) ->
      expect(treeID).to.be.equal("Pricelist")

describe 'Activity Types', ->
  it "Create basic activityType", ->
    driver.get url + "/#/activitytypes/"
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "Label").sendKeys "Customer Visit"
    driver.findElement(xpath: "(//button[@class='btn btn-default'])[3]").click()
    driver.findElement(id: "options").sendKeys "Made a Sale"
    driver.findElement(id: "addoption").click()
    driver.findElement(id: "options").sendKeys "Buyer not in"
    driver.findElement(id: "addoption").click()
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']")
    ), 10000, '\nFailed to create activitytypes'
    driver.findElement(linkText: "Back").click()

  it "Create pipeline activityType", ->
    driver.get url + "/#/activitytypes/"
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "Label").sendKeys "Cold Call"
    driver.findElement(id: "pipeline").click()
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']")
    ), 10000, '\nFailed to create activitytypes'

describe 'Discount Conditions', ->
  it "Create group/product discount", ->
    driver.get url + "/#/discount/"
    driver.sleep 500
    driver.findElement(linkText: "New Discount").click()
    driver.findElement(id: "DiscountID").sendKeys "GP"
    driver.findElement(id: "Name").sendKeys "Group Price"
    driver.findElement(id: "Type").sendKeys "p"
    driver.findElement(id: "SortOrder").sendKeys "1"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']")
    ), 10000, '\nFailed to create Discount'
    # Go back and re-select so we can add the conditions
    driver.findElement(linkText: "Back").click()
    driver.sleep 1000
    driver.findElement(xpath: "(//a[@class='list-group-item ng-scope'])[1]").click()
  it "Create account condition", ->
    driver.findElement(linkText: "Discount Conditions").click()
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "RTObject").sendKeys "#A"
    driver.findElement(id: "RTField").sendKeys "AccountG"
    driver.findElement(id: "DiscountField").sendKeys "AccountG"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "(//a[@class='list-group-item ng-scope'])[1]")
    ), 10000, "\nFailed to save discountcondition"
  it "Create product condition", ->
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "RTObject").sendKeys "#P"
    driver.findElement(id: "RTField").sendKeys "Prod"
    driver.findElement(id: "DiscountField").sendKeys "Prod"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "(//a[@class='list-group-item ng-scope'])[2]")
    ), 10000, "\nFailed to save discountcondition"
  it "Create account/product discount", ->
    driver.get url + "/#/discount/"
    driver.sleep 500
    driver.findElement(linkText: "New Discount").click()
    driver.findElement(id: "DiscountID").sendKeys "AP"
    driver.findElement(id: "Name").sendKeys "Account Price"
    driver.findElement(id: "Type").sendKeys "p"
    driver.findElement(id: "SortOrder").sendKeys "1"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']")
    ), 10000, '\nFailed to create Discount'
    # Go back and re-select so we can add the conditions
    driver.findElement(linkText: "Back").click()
    driver.sleep 1000
    driver.findElement(xpath: "(//a[@class='list-group-item ng-scope'])[1]").click()
  it "Create account condition", ->
    driver.findElement(linkText: "Discount Conditions").click()
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "RTObject").sendKeys "#A"
    driver.findElement(id: "RTField").sendKeys "AccountID"
    driver.findElement(id: "DiscountField").sendKeys "AccountID"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "(//a[@class='list-group-item ng-scope'])[1]")
    ), 10000, "\nFailed to save discountcondition"
  it "Create product condition", ->
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "RTObject").sendKeys "#P"
    driver.findElement(id: "RTField").sendKeys "Prod"
    driver.findElement(id: "DiscountField").sendKeys "Prod"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "(//a[@class='list-group-item ng-scope'])[2]")
    ), 10000, "\nFailed to save discountcondition"

describe "Create products", ->
  it "Create BIKE1", ->
    driver.get url + "/#/prodedit/"
    #Create product 1
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "ProductID").sendKeys "BIKE1"
    driver.findElement(id: "Description").sendKeys "Mountain Bike 1"
    driver.findElement(id: "CategoryName").sendKeys "MB"
    driver.findElement(id: "VAT").sendKeys "14"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
      ), 10000, "\nCould not create product 1"
  it "Create BIKE2", ->
    driver.findElement(linkText: "Back").click()
    driver.sleep 1000
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "ProductID").sendKeys "BIKE2"
    driver.findElement(id: "Description").sendKeys "Mountain Bike 2"
    driver.findElement(id: "CategoryName").sendKeys "MB"
    driver.findElement(id: "VAT").sendKeys "14"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
      ), 10000, "\nCould not create product 2"
  it "Create BIKE3", ->
    driver.findElement(linkText: "Back").click()
    driver.sleep 1000
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "ProductID").sendKeys "BIKE3"
    driver.findElement(id: "Description").sendKeys "Racing Bike 1"
    driver.findElement(id: "CategoryName").sendKeys "RB"
    driver.findElement(id: "VAT").sendKeys "14"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
      ), 10000, "\nCould not create product 3"
  it "Create BIKE4", ->
    driver.findElement(linkText: "Back").click()
    driver.sleep 1000
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "ProductID").sendKeys "BIKE4"
    driver.findElement(id: "Description").sendKeys "Racing Bike 2"
    driver.findElement(id: "CategoryName").sendKeys "RB"
    driver.findElement(id: "VAT").sendKeys "14"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
      ), 10000, "\nCould not create product 4"

describe "Create Categories", ->
  it "Create Bikes categories", ->
    driver.get url + "/#/prodcat/"
    driver.findElement(linkText: "New").click()
    driver.findElement(id: "CategoryID").sendKeys "BIKES"
    driver.findElement(id: "Description").sendKeys "Bikes"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
      ), 10000, "\nCould not create BIKES"
  it "Create Racing Bikes", ->
    driver.sleep 1000
    driver.findElement(xpath: "(//a[@id='add'])[1]").click()
    driver.findElement(id: "CategoryID").sendKeys "RB"
    driver.findElement(id: "Description").sendKeys "Racing Bikes"
    driver.findElement(id: "mode").sendKeys "c"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
      ), 10000, "\nCould not create Racing BIKES"
  it "Create Mountain Bikes", ->
    driver.sleep 1000
    driver.findElement(linkText: "Back").click()
    driver.wait (->
      driver.isElementPresent(xpath: "(//a[@id='add'])[1]")
      ), 10000, "\nCould not create category"
    driver.findElement(xpath: "(//a[@id='add'])[1]").click()
    driver.findElement(id: "CategoryID").sendKeys "MB"
    driver.findElement(id: "Description").sendKeys "Mountain Bikes"
    driver.findElement(id: "mode").sendKeys "c"
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
    ), 10000, "\nCould not create Mountain BIKES"
    driver.findElement(linkText: "Back").click()

describe "Create Pricelist", ->
  it "Create pricelist", ->
    driver.sleep 1000
    driver.get url + "/#/prices/"
    driver.findElement(linkText: "Pricelist").click()
    driver.sleep 1000
    driver.findElement(id: "ID").sendKeys "A"
    driver.findElement(id: "Name").sendKeys "Pricelist A"
    driver.findElement(xpath: "//button[@class='btn btn-primary']").click()
    driver.wait (->
      driver.isElementPresent(id: "plist")
    ), 10000, "\nCould not create pricelist A"
    driver.sleep 4000
    driver.get url + "/#/prices/A"
  it "Create price for Bike 1", ->
    driver.findElement(id: "newProduct").sendKeys "BIKE1"
    driver.findElement(id: "newPrice").sendKeys "8000"
    driver.sleep 500
    driver.findElement(id: "addPrice").click()
  it "Create price for Bike 2", ->
    driver.findElement(id: "newProduct").sendKeys "BIKE2"
    driver.findElement(id: "newPrice").sendKeys "10000"
    driver.findElement(id: "addPrice").click()
    driver.sleep 500
  it "Create price for Bike 3", ->
    driver.findElement(id: "newProduct").sendKeys "BIKE3"
    driver.findElement(id: "newPrice").sendKeys "11000"
    driver.findElement(id: "addPrice").click()
    driver.sleep 500
  it "Create price for Bike 4", ->
    driver.findElement(id: "newProduct").sendKeys "BIKE4"
    driver.findElement(id: "newPrice").sendKeys "12000"
    driver.findElement(id: "addPrice").click()
    driver.sleep 500
  it "Save Pricelist", ->
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
    ), 10000, "\nCould not save pricelist"

describe "Discount Values", ->
  it "Group/Product Prices", ->
    driver.get url + "/#/dv/"
    driver.sleep 1000
    driver.findElement(xpath: "//a[div/div='AccountGroup']").click()
    driver.sleep 1000
    driver.findElement(xpath: "//a[div/div='Big Stores']").click()
    driver.sleep 500
    driver.findElement(id: "productid").sendKeys "BIKE1"
    driver.findElement(id: "qtylow").sendKeys "0"
    driver.findElement(id: "qtyhigh").sendKeys "9999"
    driver.findElement(id: "pricebox").sendKeys "7000"
    driver.findElement(id: "addBtn").click()
    driver.sleep 1000
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
    ), 10000, "\nCould not create discountvalue"
  it "Customer/Product Prices", ->
    driver.get url + "/#/dv/"
    driver.sleep 1000
    driver.findElement(xpath: "//a[div/div='AccountID']").click()
    driver.sleep 2000
    driver.findElement(xpath: "//a[div/div='TDD1']").click()
    driver.sleep 1000
    driver.findElement(id: "productid").sendKeys "BIKE1"
    driver.findElement(id: "qtylow").sendKeys "0"
    driver.findElement(id: "qtyhigh").sendKeys "9999"
    driver.findElement(id: "pricebox").sendKeys "6000"
    driver.findElement(id: "addBtn").click()
    driver.sleep 1000
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
    ), 10000, "\nCould not create discountvalue"

describe "Promotions", ->
  it "Promo Details", ->
    driver.get url + "#/promo"
    driver.sleep 1000
    driver.findElement(linkText: "New Promotion").click()
    driver.findElement(id: "promoID").sendKeys "ZZZ10FOR1"
    driver.findElement(id: "Description").sendKeys "Buy 10 get one free"
    driver.findElement(id: "endDate").clear()
    driver.findElement(id: "endDate").sendKeys "2016-12-01"
    # Details
    driver.findElement(linkText: "Details").click()
    driver.findElement(id: "pmode").sendKeys "B"
    driver.findElement(id: "BuyQty").sendKeys "10"
    driver.findElement(id: "FreeQty").sendKeys "1"
    # Account condition
    driver.findElement(linkText: "Account Condition").click()
    driver.findElement(id: "objpropAC").sendKeys "AccountGroup"
    driver.findElement(xpath: "//button[@class='btn btn-primary ng-binding']").click()
    driver.sleep 500
    driver.findElement(id: "search").sendKeys "bi"
    driver.findElement(id: "searchbtn").click()
    driver.sleep 1000
    driver.findElement(xpath: "//a[div='Big Stores']").click()
    driver.findElement(xpath: "//button[@class='btn btn-default']").click()
    driver.sleep 500
    # Product condition
    driver.findElement(linkText: "Product Condition").click()
    driver.findElement(id: "objpropPC").sendKeys "Ca"
    driver.findElement(id: "prodSearch").click()
    driver.sleep 500
    driver.findElement(id: "search").clear()
    driver.findElement(id: "search").sendKeys "b"
    driver.findElement(id: "searchbtn").click()
    driver.sleep 1000
    driver.findElement(xpath: "//a[div='MB']").click()
    driver.findElement(xpath: "//button[@class='btn btn-default']").click()
    driver.sleep 500
    # Free products
    driver.findElement(linkText: "Free Items").click()
    driver.findElement(id: "freeProdBtn").click()
    driver.sleep 500
    driver.findElement(id: "search").clear()
    driver.findElement(id: "search").sendKeys "bike"
    driver.findElement(id: "searchbtn").click()
    driver.sleep 1000
    driver.findElement(xpath: "//a[div='BIKE1']").click()
    driver.findElement(xpath: "//button[@class='btn btn-default']").click()
    driver.sleep 500
    driver.findElement(linkText: "Save").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']")
    ), 10000, "\nCould not create discountvalue"
    screenshot "Promotions"

  ###
  # take a snapshot
  ###
  screenshot = (step) ->
    driver.takeScreenshot().then (image, err) ->
      require('fs').writeFile 'out.png', image, 'base64', (err) ->
        console.log err
        return
      return
