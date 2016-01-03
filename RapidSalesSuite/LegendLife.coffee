#mocha LegendLife.coffee --compilers coffee:coffee-script/register --timeout 30000

selenium = require "selenium-webdriver"
chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect


before ->
  @timeout = 8000
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build()
  driver.getWindowHandle()

after ->
  #driver.quit()

describe 'LegendLife', ->
  beforeEach ->
    driver.get 'http://localhost/git/rapidsales'

  it "try to login" , ->
    driver.findElement(id: 'exampleInputEmail1').sendKeys 'gregb'
    driver.findElement(id: 'exampleInputPassword1').sendKeys 'jack1234'
    driver.findElement(xpath: "//button[@type='submit']").click()
    driver.wait (->
      driver.isElementPresent(linkText :'Edit')
    ), 30000, '\nFailed to load Welcome page.'

  it "Expect 6 Pink Caps", ->
    performSearch "pink cap"
    driver.findElements(id: "productid").then (elements) ->
      expect(elements.length).to.be.above 4
      return

  it "Sort By Quantity" , ->
    performSearch "pink cap"
    driver.findElement(id: "btnSortBy").click()
    driver.findElement(linkText: "Quantity").click().then ->
      driver.sleep 500
    driver.findElement(xpath: "(//span[@id='stock'])[1]").getText().then (first) ->
      driver.findElement(xpath: "(//span[@id='stock'])[3]").getText().then (last) ->
        expect(last).to.be.below(first)

  it "Sort by Price", ->
    performSearch "pink cap"
    driver.findElement(id: "btnSortBy").click()
    driver.findElement(linkText: "Price").click().then ->
      driver.sleep(500)
    driver.findElement(xpath: "(//div[@class='list-group-item-heading plprice ng-binding'])[1]").getText().then (price1) ->
      driver.findElement(xpath: "(//div[@class='list-group-item-heading plprice ng-binding'])[6]").getText().then (price2) ->
        expect(price1).to.be.below(price2)

  it "Check currency is $", ->
    performSearch "purple cap"
    driver.findElement(xpath: "(//div[@class='list-group-item-heading plprice ng-binding'])[1]").getText().then (price) ->
      expect(price).to.have.string('$')

  it "Check product long text", ->
    selectFirst "purple cap"
    driver.findElement(xpath: "//div[@class='ng-binding']/p").getText().then (txt) -> expect(txt).to.have.string("Heavy")

  it "Email picture", ->
    selectFirst "purple cap"
    driver.findElement(xpath: "//button[@class='btn btn-default btn-block']").click()
    driver.wait (->
      driver.isElementPresent(xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']")
    ), 30000, '\nFailed to get email success'

  it "search via Categories", ->
    driver.get("http://localhost/git/rapidsales/#/products/categories")
    driver.sleep(500)
    driver.findElement(xpath: "//a[@id='BB']").click().then -> driver.sleep(500)
    driver.findElement(xpath: "//a[@id='BBCS']").click().then -> driver.sleep(500)
    driver.findElement(xpath: "//a[@id='BBCS4008A']").click().then -> driver.sleep(500)
    driver.wait (->
      driver.isElementPresent(xpath: "(//span[@id='stock'])[1]")
    ), 30000, '\nNo Products found for category.'

  it "Check volume discounts", ->
    performSearch "1195"
    driver.findElement(xpath: "(//div[@class='list-group-item-heading plprice ng-binding'])[1]").getText().then (price1) ->
      console.log "sleep"
      driver.sleep 3000
      driver.findElement(xpath: "(//input[@id='Quantity'])[1]").sendKeys "1000"
      driver.findElement(xpath: "(//div[@class='list-group-item-heading plprice ng-binding'])[1]").getText().then (price2) ->
        expect(price2).to.be.below(price1)

  ###
  #  Perform a product search and wait for at least 1 stock column to appear
  ###
  performSearch = (searchStr) ->
    driver.get "http://localhost/git/rapidsales/#/products"
    driver.sleep(1000)
    driver.findElement(id: "searchbox").clear()
    driver.findElement(id: "searchbox").sendKeys searchStr
    driver.findElement(css: "button.btn.btn-success").click()
    driver.wait (->
      driver.isElementPresent(xpath: "(//span[@id='stock'])[1]")
    ), 30000, '\nFailed to show a pricelist.'

  ###
  # Perform a search and select the first product in the list
  ###
  selectFirst = (searchStr) ->
    performSearch searchStr
    driver.findElement(xpath: "(//div[@id='productid'])[1]").click().then -> driver.sleep(3000)


  ###
  # take a snapshot
  ###
  screenshot = (step) ->
    driver.takeScreenshot().then (image, err) ->
      require('fs').writeFile 'out.png', image, 'base64', (err) ->
        console.log err
        return
      return

###
  it 'Wait for edit button to appear', ->
    expect(@driver.findElement(linkText: 'Edit')).to.eventually.contain 'Getting started with Selenium Webdriver for node.js'

  it 'has publication date', ->
    text = @driver.findElement(css: '.post .meta time').getText()
    expect(text).to.eventually.equal 'December 30th, 2014'

  it 'links back to the homepage', ->
    @driver.findElement(linkText: 'Bites').click()
    expect(@driver.getCurrentUrl()).to.eventually.equal 'http://bites.goodeggs.com/'

    #driver.findElement(id: "searchbox").sendKeys selenium.Key.ENTER

          #console.log 'elements: ' + elements.length
          #console.log 'class: ' + elements[0].getAttribute('class')
###

###
driver.wait (->
  driver.isElementPresent(linkText :'Search Products')
), 10000, '\nFailed to find search products.'
driver.findElement(linkText: 'Search Products').click()
driver.findElement(id: "searchbox").sendKeys "pink cap"
driver.findElement(css: "button.btn.btn-success").click().then ->
  driver.sleep 4000
###
