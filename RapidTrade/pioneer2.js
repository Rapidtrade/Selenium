var chai, expect, selenium, waitFor;

selenium = require("selenium-webdriver");
chai = require('chai');
chai.use(require('chai-as-promised'));
expect = chai.expect;

before(function() {
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build();
  global.url = "http://localhost/git/rapidtrade";
  global.waittime = 60000;
  global.pause = 1000;
  driver.getWindowHandle();
  driver.get(url);
  driver.findElement({id: 'exampleInputEmail1'}).sendKeys('PIONEER');
  driver.findElement({id: 'exampleInputPassword1'}).sendKeys('PASSWORD');
  driver.findElement({xpath: "//button[@type='submit']"}).click();
  waitFor({linkText: 'Admin' }, 'Failed to load Welcome page');
  return driver.sleep(1000);
});

describe('Test stock controller', function() {
  it("Create test deliveries for today for routes TDD1 and TDD2", function() {
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_clear&supplierid=%27pioneer%27&routeid=%27TDD1%27");
    waitFor({xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162291608025984%27&Reference=%27INV211%27");
    waitFor({xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162362309593149%27&Reference=%27INV211%27");
    waitFor({xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD2%27&AccountID=%27162352211253236%27&Reference=%27INV212%27");
    return waitFor({xpath: "/html/body/pre"}, "Did not get a result");
  });

  it("Choose route WC1", function() {
    driver.get(url + "#/replenish");
    return driver.findElement({xpath: "//div[text()='TDD1']"}).click();
  });

  it("Create replenishment", function() {});

  it("Create another delivery for TDD1", function() {
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162291608025984%27&Reference=%27INV211%27");
    return waitFor({xpath: "/html/body/pre"}, "Did not get a result");
  });
  return it("Check replenish proposal has increased delivery quantities", function() {});
});

describe('Test driver GRV', function() {
  it("Create test deliveries, then a replenishment for today for routes TDD1", function() {
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_clear&supplierid=%27pioneer%27&routeid=%27TDD1%27");
    waitFor({xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162291608025984%27&Reference=%27INV211%27");
    waitFor({ xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27pioneer%27&routeid=%27TDD1%27&AccountID=%27162352211253236%27&Reference=%27INV212%27");
    waitFor({xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_create&supplierid=%27pioneer%27&routeid=%27TDD1%27");
    return waitFor({xpath: "/html/body/pre"}, "Did not get a result");
  });

  it("Driver selects route", function() {});

  it("Driver accepts GRV and Load", function() {});

  it("Driver views the deliveries", function() {});

  return it("Check stock controller can no longer create replenishments for those deliverues");
});

describe.only('Test driver POD', function() {
  it("Create test deliveries, replenishment & GRV for today for routes TDD1", function() {
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_clear&supplierid=%27PIONEER%27&routeid=%27TDD1%27");
    waitFor({xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27PIONEER%27&routeid=%27TDD1%27&AccountID=%27162291608025984%27&Reference=%27INV211%27");
    waitFor({ xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_delivery_create&supplierid=%27PIONEER%27&routeid=%27TDD1%27&AccountID=%27162352211253236%27&Reference=%27INV212%27");
    waitFor({xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_replenish_create&supplierid=%27PIONEER%27&routeid=%27TDD1%27");
    waitFor({xpath: "/html/body/pre"}, "Did not get a result");
    driver.get("http://api.rapidtrade.biz/rest/Get?method=tdd_grv_create&supplierid=%27PIONEER%27&routeid=%27TDD1%27&DriverID=%27PDRIVER1%27");
    return waitFor({xpath: "/html/body/pre"}, "Did not get a result");
  });
  it("Sync so that our days stock comes down", function() {});

  it("Go to my deliveries", function() {});

  return it("Deliver INV211", function() {});
});

waitFor = function(xpathelement, message) {
  return driver.wait((function() {
    return driver.isElementPresent(xpathelement);
  }), waittime, "\n" + message);
};

// ---
// generated by coffee-script 1.9.2
