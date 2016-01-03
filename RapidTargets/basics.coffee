# mocha basics.coffee --compilers coffee:coffee-script/register --timeout 30000

selenium = require "selenium-webdriver"
chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect


before ->
  @timeout = 8000
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build()
  global.url = "http://localhost/git/rapidtargets"
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



  ###
  # take a snapshot
  ###
  screenshot = (step) ->
    driver.takeScreenshot().then (image, err) ->
      require('fs').writeFile 'out.png', image, 'base64', (err) ->
        console.log err
        return
      return
