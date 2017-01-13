// mocha core.js --timeout 6000000
var chai, expect, screenshot, selenium, waitFor;

selenium = require("selenium-webdriver");

chai = require('chai');

chai.use(require('chai-as-promised'));

expect = chai.expect;

before(function() {
  this.timeout = 8000;
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build();
  global.url = "http://localhost/git/angularcore";
  global.timeout = 20000;
  driver.getWindowHandle();
  driver.get(url);
  driver.findElement({id: 'exampleInputEmail1'}).sendKeys('TDD');
  driver.findElement({id: 'exampleInputPassword1'}).sendKeys('PASSWORD');
  driver.findElement({xpath: "//button[@type='submit']"}).click();
  driver.wait((function() {
    return driver.isElementPresent({linkText: 'Admin'});
  }), 30000, '\nFailed to load Welcome page.');
  return driver.sleep(1000);
});


/*
after ->
  driver.quit()
 */

describe('Reset TDD data', function() {
  return it("Reset TDD supplier", function() {
    driver.get(url + "/#/test/");
    driver.sleep(500);
    driver.findElement({id: "resetBtn"}).click();
    return driver.wait((function() {
      return driver.isElementPresent({id: 'successmsg'});
    }), timeout, '\nFailed to reset data.');
  });
});

describe('Create Users', function() {
  it("Create manager", function() {
    driver.get(url + "/#/users/");
    driver.findElement({linkText: "New"}).click();
    driver.findElement({id: "UserID"}).sendKeys("TDDMANAGER");
    driver.findElement({id: "Name"}).sendKeys("TDD manager");
    driver.findElement({id: "Password"}).sendKeys("PASSWORD");
    driver.findElement({xpath: "//div[@class='checkbox'][2]/label/input"}).click();
    driver.findElement({linkText: "Save"}).click();
    return driver.wait((function() {
      return driver.isElementPresent({xpath: "//div[@class='alert alert-success ng-binding ng-scope']"});
    }), timeout, "\nFailed to create user");
  });
  it("Create rep 2", function() {
    driver.get(url + "/#/users/");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "UserID"
    }).sendKeys("TDD2");
    driver.findElement({
      id: "Name"
    }).sendKeys("TDD Rep 2");
    driver.findElement({
      id: "Password"
    }).sendKeys("PASSWORD");
    driver.findElement({
      id: "Manager"
    }).sendKeys("TDD M");
    driver.findElement({
      xpath: "//div[@class='checkbox'][2]/label/input"
    }).click();
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert alert-success ng-binding ng-scope']"
      });
    }), timeout, "\nFailed to create user");
  });
  return it("Create options", function() {
    driver.get(url + "/#/options/");
    driver.findElement({
      linkText: "New Option"
    }).click();
    driver.findElement({
      id: "Name"
    }).sendKeys("CanChangeDiscount");
    driver.findElement({
      id: "Group"
    }).sendKeys("Online");
    driver.findElement({
      id: "Value"
    }).sendKeys("true");
    driver.findElement({
      id: "Type"
    }).sendKeys("T");
    driver.findElement({
      linkText: "Save"
    }).click();
    return waitFor({
      xpath: "//div[@class='alert alert-success ng-binding ng-scope']"
    }, "\nFailed to create option");
  });
});

describe.only('Create User Exit & Tree', function() {
  it("Create User Exit", function() {
    driver.get(url + "/#/userexit/");
    driver.findElement({linkText: "New"}).click();
    driver.sleep(2000);
    driver.findElement({id: "UserExitID"}).sendKeys("A");
    driver.sleep(1000);
    driver.findElement({id: "Code"}).sendKeys("alert 'hello';");
    driver.findElement({linkText: "Save"}).click();
    driver.sleep(1000);
    return driver.wait((function() {
      return driver.isElementPresent({xpath: "//div[@class='alert alert-success ng-binding ng-scope']"});
    }), timeout, "\nFailed to save user exit");
  });
  return it("Create tree", function() {
    driver.get(url + "/#/tree/");
    driver.findElement({linkText: "New Tree"}).click();
    driver.findElement({id: "TreeID"}).sendKeys("PL");
    driver.findElement({id: "Description"}).sendKeys("Pricelist");
    driver.findElement({id: "ParentTreeID"}).sendKeys("");
    driver.findElement({id: "Tags"}).sendKeys("");
    driver.findElement({id: "Tips"}).sendKeys("#/pricelist");
    driver.findElement({id: "SortOrder"}).sendKeys("1");
    driver.findElement({linkText: "Save"}).click();
    driver.wait((function() {
      return driver.isElementPresent({xpath: "//a[@class='list-group-item ng-scope']"});
    }), timeout, "\nFailed to save tree");
    driver.sleep(3000);
    return driver.findElement({xpath: "//div[@class='col-xs-3 ng-binding'][1]"}).getText().then(function(treeID) {
      return expect(treeID).to.be.equal("");
    });
  });
});

describe('Activity Types', function() {
  it("Create basic activityType", function() {
    driver.get(url + "/#/activitytypes/");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ActivityTypeID"
    }).clear();
    driver.findElement({
      id: "ActivityTypeID"
    }).sendKeys("CHECKIN");
    driver.findElement({
      id: "Label"
    }).sendKeys("Checkin");
    driver.findElement({
      xpath: "(//button[@class='btn btn-default'])[3]"
    }).click();
    driver.findElement({
      id: "options"
    }).sendKeys("Made a Sale");
    driver.findElement({
      id: "addoption"
    }).click();
    driver.findElement({
      id: "options"
    }).sendKeys("Buyer not in");
    driver.findElement({
      id: "addoption"
    }).click();
    driver.findElement({
      linkText: "Save"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']"
      });
    }), timeout, '\nFailed to create activitytypes');
    return driver.findElement({
      linkText: "Back"
    }).click();
  });
  it("Create pipeline Cold Call activityType", function() {
    driver.get(url + "/#/activitytypes/");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ActivityTypeID"
    }).clear();
    driver.findElement({
      id: "ActivityTypeID"
    }).sendKeys("CC");
    driver.findElement({
      id: "Label"
    }).sendKeys("Cold Call");
    driver.findElement({
      id: "pipeline"
    }).click();
    driver.findElement({
      id: "PercentageComplete"
    }).clear();
    driver.findElement({
      id: "PercentageComplete"
    }).sendKeys("10");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']"
      });
    }), timeout, '\nFailed to create cold call activitytypes');
  });
  it("Create pipeline First Meeting activityType", function() {
    driver.get(url + "/#/activitytypes/");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ActivityTypeID"
    }).clear();
    driver.findElement({
      id: "ActivityTypeID"
    }).sendKeys("FM");
    driver.findElement({
      id: "Label"
    }).sendKeys("First Meeting");
    driver.findElement({
      id: "pipeline"
    }).click();
    driver.findElement({
      id: "PercentageComplete"
    }).clear();
    driver.findElement({
      id: "PercentageComplete"
    }).sendKeys("30");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']"
      });
    }), timeout, '\nFailed to create first meeting activitytypes');
  });
  it("Create pipeline proposal activityType", function() {
    driver.get(url + "/#/activitytypes/");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ActivityTypeID"
    }).clear();
    driver.findElement({
      id: "ActivityTypeID"
    }).sendKeys("PRO");
    driver.findElement({
      id: "Label"
    }).sendKeys("Proposal");
    driver.findElement({
      id: "pipeline"
    }).click();
    driver.findElement({
      id: "PercentageComplete"
    }).clear();
    driver.findElement({
      id: "PercentageComplete"
    }).sendKeys("50");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']"
      });
    }), timeout, '\nFailed to create proposal activitytypes');
  });
  return it("Create pipeline award activityType", function() {
    driver.get(url + "/#/activitytypes/");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ActivityTypeID"
    }).clear();
    driver.findElement({
      id: "ActivityTypeID"
    }).sendKeys("AWA");
    driver.findElement({
      id: "Label"
    }).sendKeys("Awarded");
    driver.findElement({
      id: "pipeline"
    }).click();
    driver.findElement({
      id: "PercentageComplete"
    }).clear();
    driver.findElement({
      id: "PercentageComplete"
    }).sendKeys("100");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']/span[@class='ng-binding']"
      });
    }), timeout, '\nFailed to create proposal activitytypes');
  });
});

describe('Discount GP Conditions', function() {
  it("Create group/product discount", function() {
    driver.get(url + "/#/discount/");
    driver.sleep(500);
    driver.findElement({
      linkText: "New Discount"
    }).click();
    driver.findElement({
      id: "DiscountID"
    }).sendKeys("GP");
    driver.findElement({
      id: "Name"
    }).sendKeys("Group Price");
    driver.findElement({
      id: "Type"
    }).sendKeys("p");
    driver.findElement({
      id: "SortOrder"
    }).sendKeys("2");
    driver.findElement({
      id: "SkipRest"
    }).click();
    driver.findElement({
      id: "OverwriteDiscount"
    }).click();
    driver.findElement({
      linkText: "Save"
    }).click();
    waitFor({
      linkText: "Discount Conditions"
    }, "\nFailed to create Discount");
    return driver.sleep(4000);
  });
  it("Create account condition", function() {
    driver.findElement({
      linkText: "Discount Conditions"
    }).click();
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "RTObject"
    }).sendKeys("#A");
    driver.findElement({
      id: "RTField"
    }).sendKeys("AccountG");
    driver.findElement({
      id: "DiscountField"
    }).sendKeys("AccountG");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "(//a[@class='list-group-item ng-scope'])[1]"
      });
    }), timeout, "\nFailed to save discountcondition");
  });
  return it("Create product condition", function() {
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "RTObject"
    }).sendKeys("#P");
    driver.findElement({
      id: "RTField"
    }).sendKeys("Prod");
    driver.findElement({
      id: "DiscountField"
    }).sendKeys("Prod");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "(//a[@class='list-group-item ng-scope'])[2]"
      });
    }), timeout, "\nFailed to save discountcondition");
  });
});

describe('Discount AP Conditions', function() {
  it("Create account/product discount", function() {
    driver.get(url + "/#/discount/");
    driver.sleep(1000);
    driver.findElement({
      linkText: "New Discount"
    }).click();
    driver.findElement({
      id: "DiscountID"
    }).sendKeys("AP");
    driver.findElement({
      id: "Name"
    }).sendKeys("Account Price");
    driver.findElement({
      id: "Type"
    }).sendKeys("p");
    driver.findElement({
      id: "SortOrder"
    }).sendKeys("1");
    driver.findElement({
      id: "SkipRest"
    }).click();
    driver.findElement({
      id: "OverwriteDiscount"
    }).click();
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        linkText: "Discount Conditions"
      });
    }), timeout, '\nFailed to create Discount');
  });
  it("Create account condition", function() {
    driver.findElement({
      linkText: "Discount Conditions"
    }).click();
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "RTObject"
    }).sendKeys("#A");
    driver.findElement({
      id: "RTField"
    }).sendKeys("AccountID");
    driver.findElement({
      id: "DiscountField"
    }).sendKeys("AccountID");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "(//a[@class='list-group-item ng-scope'])[1]"
      });
    }), timeout, "\nFailed to save discountcondition");
  });
  return it("Create product condition", function() {
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "RTObject"
    }).sendKeys("#P");
    driver.findElement({
      id: "RTField"
    }).sendKeys("Prod");
    driver.findElement({
      id: "DiscountField"
    }).sendKeys("Prod");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "(//a[@class='list-group-item ng-scope'])[2]"
      });
    }), timeout, "\nFailed to save discountcondition");
  });
});

describe("Create products", function() {
  it("Create BIKE1", function() {
    driver.get(url + "/#/prodedit/");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ProductID"
    }).sendKeys("BIKE1");
    driver.findElement({
      id: "Description"
    }).sendKeys("Mountain Bike 1");
    driver.findElement({
      id: "CategoryName"
    }).sendKeys("MB");
    driver.findElement({
      id: "VAT"
    }).sendKeys("14");
    driver.findElement({
      linkText: "Save"
    }).click();
    return waitFor({
      xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
    }, "Could not save");
  });
  it("Create BIKE2", function() {
    driver.findElement({
      linkText: "Back"
    }).click();
    waitFor({
      id: "exampleInputAmount"
    }, "Cant create new product");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ProductID"
    }).sendKeys("BIKE2");
    driver.findElement({
      id: "Description"
    }).sendKeys("Mountain Bike 2");
    driver.findElement({
      id: "CategoryName"
    }).sendKeys("MB");
    driver.findElement({
      id: "VAT"
    }).sendKeys("14");
    driver.findElement({
      linkText: "Save"
    }).click();
    return waitFor({
      xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
    }, "Could not save");
  });
  it("Create BIKE3", function() {
    driver.findElement({
      linkText: "Back"
    }).click();
    driver.sleep(1000);
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ProductID"
    }).sendKeys("BIKE3");
    driver.findElement({
      id: "Description"
    }).sendKeys("Racing Bike 1");
    driver.findElement({
      id: "CategoryName"
    }).sendKeys("RB");
    driver.findElement({
      id: "VAT"
    }).sendKeys("14");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create product 3");
  });
  return it("Create BIKE4", function() {
    driver.findElement({
      linkText: "Back"
    }).click();
    driver.sleep(1000);
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "ProductID"
    }).sendKeys("BIKE4");
    driver.findElement({
      id: "Description"
    }).sendKeys("Racing Bike 2");
    driver.findElement({
      id: "CategoryName"
    }).sendKeys("RB");
    driver.findElement({
      id: "VAT"
    }).sendKeys("14");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create product 4");
  });
});

describe("Create Categories", function() {
  it("Create Bikes categories", function() {
    driver.get(url + "/#/prodcat/");
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "CategoryID"
    }).sendKeys("BIKES");
    driver.findElement({
      id: "Description"
    }).sendKeys("Bikes");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "(//a[@id='add'])[1]"
      });
    }), timeout, "\nCould not create BIKES");
  });
  it("Create Racing Bikes", function() {
    driver.findElement({
      xpath: "(//a[@id='add'])[1]"
    }).click();
    driver.findElement({
      id: "CategoryID"
    }).sendKeys("RB");
    driver.findElement({
      id: "Description"
    }).sendKeys("Racing Bikes");
    driver.findElement({
      id: "mode"
    }).sendKeys("c");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create Racing BIKES");
  });
  return it("Create Mountain Bikes", function() {
    driver.get(url + "#/prodcat");
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "(//a[@id='add'])[1]"
      });
    }), timeout, "\nCould not get categories");
    driver.findElement({
      xpath: "(//a[@id='add'])[1]"
    }).click();
    driver.findElement({
      id: "CategoryID"
    }).sendKeys("MB");
    driver.findElement({
      id: "Description"
    }).sendKeys("Mountain Bikes");
    driver.findElement({
      id: "mode"
    }).sendKeys("c");
    driver.findElement({
      linkText: "Save"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create Mountain BIKES");
    return driver.findElement({
      linkText: "Back"
    }).click();
  });
});

describe("Create Pricelist", function() {
  it("Create pricelist", function() {
    driver.sleep(1000);
    driver.get(url + "/#/prices/");
    driver.findElement({
      linkText: "Pricelist"
    }).click();
    driver.sleep(1000);
    driver.findElement({
      id: "ID"
    }).sendKeys("A");
    driver.findElement({
      id: "Name"
    }).sendKeys("Pricelist A");
    driver.findElement({
      xpath: "//button[@class='btn btn-primary']"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        id: "plist"
      });
    }), timeout, "\nCould not create pricelist A");
    driver.get(url + "/#/prices/A");
    return driver.sleep(4000);
  });
  it("Create price for Bike 1", function() {
    driver.findElement({
      id: "newProduct"
    }).sendKeys("BIKE1");
    driver.findElement({
      id: "newPrice"
    }).sendKeys("8000");
    driver.findElement({
      id: "addPrice"
    }).click();
    return driver.sleep(500);
  });
  it("Create price for Bike 2", function() {
    driver.findElement({
      id: "newProduct"
    }).sendKeys("BIKE2");
    driver.findElement({
      id: "newPrice"
    }).sendKeys("10000");
    driver.findElement({
      id: "addPrice"
    }).click();
    return driver.sleep(500);
  });
  it("Create price for Bike 3", function() {
    driver.findElement({
      id: "newProduct"
    }).sendKeys("BIKE3");
    driver.findElement({
      id: "newPrice"
    }).sendKeys("11000");
    driver.findElement({
      id: "addPrice"
    }).click();
    return driver.sleep(500);
  });
  it("Create price for Bike 4", function() {
    driver.findElement({
      id: "newProduct"
    }).sendKeys("BIKE4");
    driver.findElement({
      id: "newPrice"
    }).sendKeys("12000");
    driver.findElement({
      id: "addPrice"
    }).click();
    return driver.sleep(500);
  });
  return it("Save Pricelist", function() {
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not save pricelist");
  });
});

describe("Discount Values", function() {
  it("Group/Product Prices", function() {
    driver.get(url + "/#/dv/");
    waitFor({
      xpath: "//a[div/div='AccountGroup']"
    }, "Could not find account group");
    driver.findElement({
      xpath: "//a[div/div='AccountGroup']"
    }).click();
    waitFor({
      xpath: "//a[div/div='Big Stores']"
    }, "\nBig Stores did not arrive");
    driver.findElement({
      xpath: "//a[div/div='Big Stores']"
    }).click();
    waitFor({
      linkText: "Group Price"
    }, "Tab did not appear");
    driver.findElement({
      id: "productid"
    }).sendKeys("BIKE1");
    driver.findElement({
      id: "qtylow"
    }).sendKeys("0");
    driver.findElement({
      id: "qtyhigh"
    }).sendKeys("9999");
    driver.findElement({
      id: "pricebox"
    }).sendKeys("7000");
    driver.findElement({
      id: "addBtn"
    }).click();
    waitFor({
      xpath: "//div[@class='alert ng-scope top-right am-fade alert-warning']"
    }, "Did not get warning");
    driver.sleep(4000);
    driver.findElement({
      linkText: "Save"
    }).click();
    waitFor({
      xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
    }, "Could not save discount values");
    return driver.sleep(4000);
  });
  return it("Customer/Product Prices", function() {
    driver.get(url + "/#/dv/");
    waitFor({
      xpath: "//a[div/div='AccountID']"
    }, "\TDD1 did not arrive");
    driver.findElement({
      xpath: "(//a[div/div='AccountID'])[1]"
    }).click();
    waitFor({
      xpath: "//a[div/div='TDD1']"
    }, "Could not find customer");
    driver.findElement({
      xpath: "//a[div/div='TDD1']"
    }).click();
    waitFor({
      linkText: "Account Price"
    }, "Tab did not appear");
    driver.findElement({
      id: "productid"
    }).sendKeys("BIKE1");
    driver.findElement({
      id: "qtylow"
    }).sendKeys("0");
    driver.findElement({
      id: "qtyhigh"
    }).sendKeys("9999");
    driver.findElement({
      id: "pricebox"
    }).sendKeys("6000");
    driver.findElement({
      id: "addBtn"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Save"
    }).click();
    return waitFor({
      xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
    }, "\nCould not create discountvalue");
  });
});

describe("Promotions", function() {
  it("ZZZ10FOR1", function() {
    driver.get(url + "#/promo");
    driver.sleep(1000);
    driver.findElement({
      linkText: "New Promotion"
    }).click();
    driver.findElement({
      id: "promoID"
    }).sendKeys("ZZZ10FOR1");
    driver.findElement({
      id: "Description"
    }).sendKeys("BIG Buy 10 MB get one BIKE1 free");
    driver.findElement({
      id: "endDate"
    }).clear();
    driver.findElement({
      id: "endDate"
    }).sendKeys("2016-12-01");
    driver.findElement({
      linkText: "Details"
    }).click();
    driver.findElement({
      id: "pmode"
    }).sendKeys("B");
    driver.findElement({
      id: "BuyQty"
    }).sendKeys("10");
    driver.findElement({
      id: "FreeQty"
    }).sendKeys("1");
    driver.findElement({
      linkText: "Account Condition"
    }).click();
    driver.findElement({
      id: "objpropAC"
    }).sendKeys("AccountGroup");
    driver.findElement({
      xpath: "//button[@class='btn btn-primary ng-binding']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      id: "search"
    }).sendKeys("bi");
    driver.findElement({
      id: "searchbtn"
    }).click();
    driver.sleep(1000);
    driver.findElement({
      xpath: "//a[div='Big Stores']"
    }).click();
    driver.findElement({
      xpath: "//button[@class='btn btn-default']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Product Condition"
    }).click();
    driver.findElement({
      id: "objpropPC"
    }).sendKeys("Ca");
    driver.findElement({
      id: "prodSearch"
    }).click();
    driver.sleep(500);
    driver.findElement({
      id: "search"
    }).clear();
    driver.findElement({
      id: "search"
    }).sendKeys("b");
    driver.findElement({
      id: "searchbtn"
    }).click();
    driver.sleep(2000);
    driver.findElement({
      xpath: "//a[div='MB']"
    }).click();
    driver.findElement({
      xpath: "//button[@class='btn btn-default']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Free Items"
    }).click();
    driver.findElement({
      id: "freeProdBtn"
    }).click();
    driver.sleep(500);
    driver.findElement({
      id: "search"
    }).clear();
    driver.findElement({
      id: "search"
    }).sendKeys("bike");
    driver.findElement({
      id: "searchbtn"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//a[div='BIKE1']"
      });
    }), timeout, "\nCould not find bike1");
    driver.findElement({
      xpath: "//a[div='BIKE1']"
    }).click();
    driver.findElement({
      xpath: "//button[@class='btn btn-default']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Save"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create discountvalue");
    return it("ZZZRB3FOR10PCT", function() {
      driver.get(url + "#/promo");
      driver.sleep(1000);
      driver.findElement({
        linkText: "New Promotion"
      }).click();
      driver.findElement({
        id: "promoID"
      }).sendKeys("ZZZRB3FOR10PCT");
      driver.findElement({
        id: "Description"
      }).sendKeys("ALL Buy 3 RB get 10");
      driver.findElement({
        id: "endDate"
      }).clear();
      driver.findElement({
        id: "endDate"
      }).sendKeys("2016-12-01");
      driver.findElement({
        linkText: "Details"
      }).click();
      driver.findElement({
        id: "pmode"
      }).sendKeys("Buy X get y%");
      driver.findElement({
        id: "BuyQty"
      }).sendKeys("3");
      driver.findElement({
        id: "Discount"
      }).sendKeys("10");
      driver.findElement({
        id: "noOtherDiscounts"
      }).click();
      driver.findElement({
        linkText: "Account Condition"
      }).click();
      driver.findElement({
        id: "objpropAC"
      }).sendKeys("All");
      driver.sleep(500);
      driver.findElement({
        linkText: "Product Condition"
      }).click();
      driver.findElement({
        id: "objpropPC"
      }).sendKeys("Ca");
      driver.findElement({
        id: "prodSearch"
      }).click();
      driver.sleep(500);
      driver.findElement({
        id: "search"
      }).clear();
      driver.findElement({
        id: "search"
      }).sendKeys("rb");
      driver.findElement({
        id: "searchbtn"
      }).click();
      driver.sleep(2000);
      driver.findElement({
        xpath: "//a[div='RB']"
      }).click();
      driver.findElement({
        xpath: "//button[@class='btn btn-default']"
      }).click();
      driver.sleep(500);
      driver.sleep(500);
      driver.findElement({
        linkText: "Save"
      }).click();
      return driver.wait((function() {
        return driver.isElementPresent({
          xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
        });
      }), timeout, "\nCould not create discountvalue");
    });
  });
  it("ZZZ3BIKE12FOR10PCT", function() {
    driver.get(url + "#/promo");
    driver.sleep(1000);
    driver.findElement({
      linkText: "New Promotion"
    }).click();
    driver.findElement({
      id: "promoID"
    }).sendKeys("ZZZ3BIKE12FOR10PCT");
    driver.findElement({
      id: "Description"
    }).sendKeys("ALL By 3 BIKE1/BIKE2 get 10 discount");
    driver.findElement({
      id: "endDate"
    }).clear();
    driver.findElement({
      id: "endDate"
    }).sendKeys("2016-12-01");
    driver.findElement({
      linkText: "Details"
    }).click();
    driver.findElement({
      id: "pmode"
    }).sendKeys("Buy X get y%");
    driver.findElement({
      id: "BuyQty"
    }).sendKeys("3");
    driver.findElement({
      id: "Discount"
    }).sendKeys("10");
    driver.findElement({
      id: "noOtherDiscounts"
    }).click();
    driver.findElement({
      linkText: "Account Condition"
    }).click();
    driver.findElement({
      id: "objpropAC"
    }).sendKeys("All");
    driver.sleep(500);
    driver.findElement({
      linkText: "Product Condition"
    }).click();
    driver.findElement({
      id: "objpropPC"
    }).sendKeys("Pr");
    driver.findElement({
      id: "prodSearch"
    }).click();
    driver.sleep(500);
    driver.findElement({
      id: "search"
    }).clear();
    driver.findElement({
      id: "search"
    }).sendKeys("bike");
    driver.findElement({
      id: "searchbtn"
    }).click();
    driver.sleep(2000);
    driver.findElement({
      xpath: "//a[div='BIKE1']"
    }).click();
    driver.findElement({
      xpath: "//a[div='BIKE2']"
    }).click();
    driver.findElement({
      xpath: "//button[@class='btn btn-default']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create discountvalue");
  });
  return it("ZZZSML5FOR1", function() {
    driver.get(url + "#/promo");
    driver.sleep(1000);
    driver.findElement({
      linkText: "New Promotion"
    }).click();
    driver.findElement({
      id: "promoID"
    }).sendKeys("ZZZSML5FOR1");
    driver.findElement({
      id: "Description"
    }).sendKeys("Small Stores Buy 5 BIKE1 get 1 free");
    driver.findElement({
      id: "endDate"
    }).clear();
    driver.findElement({
      id: "endDate"
    }).sendKeys("2016-12-01");
    driver.findElement({
      linkText: "Details"
    }).click();
    driver.findElement({
      id: "pmode"
    }).sendKeys("B");
    driver.findElement({
      id: "BuyQty"
    }).sendKeys("10");
    driver.findElement({
      id: "FreeQty"
    }).sendKeys("1");
    driver.findElement({
      id: "notAllowedWithDeal"
    }).click();
    driver.findElement({
      linkText: "Account Condition"
    }).click();
    driver.findElement({
      id: "objpropAC"
    }).sendKeys("AccountGroup");
    driver.findElement({
      xpath: "//button[@class='btn btn-primary ng-binding']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      id: "search"
    }).sendKeys("bi");
    driver.findElement({
      id: "searchbtn"
    }).click();
    driver.sleep(1000);
    driver.findElement({
      xpath: "//a[div='Small Stores']"
    }).click();
    driver.findElement({
      xpath: "//button[@class='btn btn-default']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Product Condition"
    }).click();
    driver.findElement({
      id: "objpropPC"
    }).sendKeys("Ca");
    driver.findElement({
      id: "prodSearch"
    }).click();
    driver.sleep(500);
    driver.findElement({
      id: "search"
    }).clear();
    driver.findElement({
      id: "search"
    }).sendKeys("p");
    driver.findElement({
      id: "searchbtn"
    }).click();
    driver.sleep(2000);
    driver.findElement({
      xpath: "//a[div='BIKE1']"
    }).click();
    driver.findElement({
      xpath: "//button[@class='btn btn-default']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Free Items"
    }).click();
    driver.findElement({
      id: "freeProdBtn"
    }).click();
    driver.sleep(500);
    driver.findElement({
      id: "search"
    }).clear();
    driver.findElement({
      id: "search"
    }).sendKeys("bike");
    driver.findElement({
      id: "searchbtn"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//a[div='BIKE1']"
      });
    }), timeout, "\nCould not find bike1");
    driver.findElement({
      xpath: "//a[div='BIKE1']"
    }).click();
    driver.findElement({
      xpath: "//button[@class='btn btn-default']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create discountvalue");
  });
});

describe("Day End Activities", function() {
  it("Create Marketing", function() {
    driver.get(url + "#/dayendactivities");
    driver.sleep(500);
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "DayEndTypeID"
    }).sendKeys("MARK");
    driver.findElement({
      id: "Description"
    }).sendKeys("Marketing");
    driver.findElement({
      id: "isParent"
    }).click();
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create Marketing");
  });
  it("Create Cold Calling", function() {
    driver.get(url + "#/dayendactivities");
    driver.sleep(500);
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "DayEndTypeID"
    }).sendKeys("MCC");
    driver.findElement({
      id: "Description"
    }).sendKeys("Cold Calling");
    driver.findElement({
      id: "parent"
    }).sendKeys("MARK");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create Marketing");
  });
  it("Create social networking", function() {
    driver.get(url + "#/dayendactivities");
    driver.sleep(500);
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "DayEndTypeID"
    }).sendKeys("MSC");
    driver.findElement({
      id: "Description"
    }).sendKeys("Social Networking");
    driver.findElement({
      id: "parent"
    }).sendKeys("MARK");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create Marketing");
  });
  it("Create Customer", function() {
    driver.get(url + "#/dayendactivities");
    driver.sleep(500);
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "DayEndTypeID"
    }).sendKeys("CUST");
    driver.findElement({
      id: "Description"
    }).sendKeys("Customer");
    driver.findElement({
      id: "isParent"
    }).click();
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create Marketing");
  });
  return it("Create Customer Visits", function() {
    driver.get(url + "#/dayendactivities");
    driver.sleep(500);
    driver.findElement({
      linkText: "New"
    }).click();
    driver.findElement({
      id: "DayEndTypeID"
    }).sendKeys("CV");
    driver.findElement({
      id: "Description"
    }).sendKeys("Customer Visits");
    driver.findElement({
      id: "parent"
    }).sendKeys("CUST");
    driver.findElement({
      id: "sessionvariable"
    }).sendKeys("C");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create Marketing");
  });
});

waitFor = function(obj, message) {
  return driver.wait((function() {
    return driver.isElementPresent(obj);
  }), 30000, "\n" + message);
};

screenshot = function(step) {
  return driver.takeScreenshot().then(function(image, err) {
    require('fs').writeFile('out.png', image, 'base64', function(err) {
      console.log(err);
    });
  });
};

// ---
// generated by coffee-script 1.9.2
