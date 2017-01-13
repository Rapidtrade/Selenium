// mocha basics.js --timeout 30000
var chai, deselectDF, expect, gocustomer, newcustomer, screenshot, selectDF, selenium, waitFor;

selenium = require("selenium-webdriver");

chai = require('chai');

chai.use(require('chai-as-promised'));

expect = chai.expect;

before(function() {
  this.timeout = 8000;
  global.driver = new selenium.Builder().withCapabilities(selenium.Capabilities.chrome()).build();
  global.url = "http://localhost/git/rapidtargets";
  global.timeout = 30000;
  driver.getWindowHandle();
  driver.get(url);
  driver.findElement({
    id: 'exampleInputEmail1'
  }).sendKeys('TDD');
  driver.findElement({
    id: 'exampleInputPassword1'
  }).sendKeys('PASSWORD');
  driver.findElement({
    xpath: "//button[@type='submit']"
  }).click();
  driver.wait((function() {
    return driver.isElementPresent({
      linkText: 'Admin'
    });
  }), 30000, '\nFailed to load Welcome page.');
  return driver.sleep(1000);
});


/*
after ->
  driver.quit()
 */

describe('Reset TDD Rapidtargets data', function() {
  return it("Reset TDD supplier", function() {
    driver.get(url + "/#/test/");
    driver.sleep(500);
    driver.findElement({
      id: "resetBtn"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        id: 'successmsg'
      });
    }), timeout, '\nFailed to reset data.');
  });
});

describe("Checking Group's", function() {
  it("Create a group", function() {
    driver.get(url + "#/groups");
    driver.sleep(500);
    driver.findElement({linkText: "Create Group"}).click();
    driver.sleep(500);
    driver.findElement({id: "name"}).sendKeys("Joburg reps");
    driver.findElement({id: "Owner"}).sendKeys("Shaun");
    driver.findElement({id: "Tel"}).sendKeys("082 121 1211");
    driver.findElement({id: "Area"}).sendKeys("Joburg");
    driver.findElement({linkText: "Save"}).click();
    driver.sleep(3000);
    return waitFor({xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"}, "\nFailed to create group");
  });


  it("Goto members", function() {
    driver.get(url + "#/groups");
    waitFor({xpath: "//a/div[contains(.,'Joburg')]"}, "Could not find Joburg reps");
    driver.findElement({xpath: "//a/div[contains(.,'Joburg')]"}).click();
    driver.findElement({linkText: "Groups"}).click();
    driver.sleep(1000);
    driver.findElement({xpath: "//a/div[contains(.,'Joburg')]"}).click();
    waitFor({linkText: "Members"}, "Could not find members link");
    driver.sleep(2000);
    driver.findElement({linkText: "Members"}).click();
    return waitFor({linkText: "Invite people to your group"}, "Could not find invite link");
});

  it("Invite popup", function() {
    driver.findElement({xpath: "//div[3]/a[@class='btn btn-success btn-block']"}).click();
    waitFor({id: "UserID"}, "could not find popup");
    driver.findElement({id: "UserID"
    }).sendKeys("TDD2");
    driver.findElement({xpath: "//button[@class='btn btn-success ng-binding']"}).click();
    waitFor({xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"}, "\nFailed to invite user");
    driver.findElement({xpath: "//div[@class='modal-footer']/button[@class='btn btn-default']"}).click();
    driver.sleep(500);
    return driver.isElementPresent({
      xpath: "//a[div/div='TDD Rep 2']"
    });
  });
  return it("Dashbord message", function() {
    driver.get(url + "#/groups");
    driver.sleep(500);
    driver.findElement({xpath: "//div[span[@class='fa fa-comment-o']]"}).click();
    driver.sleep(500);
    driver.findElement({xpath: "//textarea"}).sendKeys("hello world");
    driver.findElement({xpath: "//button[@class='btn btn-success']"}).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[contains(text(),'hello world')]"
      });
    }), timeout, "\nFailed to create message");
  });
});

describe("Companies", function() {
  it("Create a new company and set displayfields", function() {
    driver.get(url + "#/myterritory");
    driver.findElement({linkText: "Company"}).click();
    driver.sleep(500);
    driver.findElement({id: "settingBtn"}).click();
    driver.sleep(2000);
    driver.findElement({xpath: "//th[4]"}).click();
    driver.sleep(500);
    deselectDF(2);
    deselectDF(3);
    deselectDF(4);
    deselectDF(5);
    deselectDF(6);
    deselectDF(7);
    selectDF("AccountID", "1", "");
    selectDF("Name", "2", "");
    selectDF("AccountGroup", "3", "");
    selectDF("Pricelist", "4", "");
    driver.executeScript("scroll(0,400)");
    driver.findElement({id: "saveBtn"}).click();
    return waitFor({xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
    }, "\nFailed to create message");
  });
  return it("Save the new customer", function() {
    newcustomer("TDD3", "Small Stores", "TDD Customer 3", "A");
    newcustomer("TDD2", "Big Stores", "TDD Customer 2", "A");
    newcustomer("TDD1", "Big Stores", "TDD Customer 1", "A");
    newcustomer("TDD4", "Small Stores", "TDD Customer 4", "A");
    return newcustomer("TDD5", "Big Stores", "TDD Customer 5", "A");
  });
});

describe("Contacts", function() {
  it("Create contact 1 for TDD1", function() {
    gocustomer("TDD Customer 1");
    driver.findElement({
      xpath: "//a[text()='Contacts']"
    }).click();
    driver.findElement({
      linkText: "Contact"
    }).click();
    driver.findElement({
      id: "Name"
    }).sendKeys("Peter Prinsloo");
    driver.findElement({
      id: "Email"
    }).sendKeys("peter@prinsloo.com");
    driver.findElement({
      id: "Mobile"
    }).sendKeys("082 121 1211");
    driver.findElement({
      id: "TEL"
    }).sendKeys("011 682 2122");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), 10000, "\nFailed to create contact");
  });
  return it("Create contact 2 for TDD1", function() {
    gocustomer("TDD Customer 1");
    driver.findElement({
      xpath: "//a[text()='Contacts']"
    }).click();
    driver.findElement({
      linkText: "Contact"
    }).click();
    driver.findElement({
      id: "Name"
    }).sendKeys("Abigail Smith");
    driver.findElement({
      id: "Email"
    }).sendKeys("abi@prinsloo.com");
    driver.findElement({
      id: "Mobile"
    }).sendKeys("082 121 1211");
    driver.findElement({
      id: "TEL"
    }).sendKeys("011 682 2122");
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), 10000, "\nFailed to create contact");
  });
});

describe.only("Activities", function() {
  it("Basic activity", function() {
    gocustomer('TDD Customer 1');
     driver.findElement({xpath: "//button[@class='selectactivitytype']"}).click();
     driver.sleep(1000);
     driver.findElement({xpath: "//a[p='Checkin']"}).click();
     driver.sleep(1000);
     driver.findElement({id: "note"}).sendKeys("Peter was not in");
     driver.findElement({xpath: "//div[p='Buyer not in']"}).click();
     driver.findElement({linkText: "Save"}).click();
     return driver.sleep(1000);
     return driver.wait((function() {
     return driver.isElementPresent({xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"});
    }), 10000, "\nCould not create activity");
  });
  it("Pipeline activity and RapidSales opportunity", function() {
    gocustomer('TDD Customer 1');
    driver.findElement({xpath: "//button[@class='selectactivitytype']"}).click();
    driver.sleep(500);
    driver.findElement({xpath: "//a[p='First Meeting'][1]"}).click();
    driver.sleep(500);
    driver.findElement({id: "note"}).sendKeys("Looks like a good company");
    driver.findElement({id: "Opportunity"}).sendKeys("test");
    driver.findElement({id: "newBtn"}).click();
    driver.sleep(500);
    driver.findElement({id: "name"}).clear();
    driver.findElement({id: "upfrontFee"}).clear();
    driver.findElement({id: "upfrontFee"}).sendKeys("1000");
    driver.findElement({id: "monthlyFee"}).clear();
    driver.findElement({id: "monthlyFee"}).sendKeys("100");
    driver.findElement({id: "closeByDate"}).clear();
    driver.findElement({id: "closeByDate"}).sendKeys("January 1, 2018");
    //driver.findElement({id: "description"}).sendKeys("Rapidsales opportunity");
    //driver.findElement({linkText: "Save"}).click();
    // return waitFor({xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"}, "\nCould not create opportunity");
    return driver.sleep(500)
  });
  // it("Check activity details are remembered and save the activity", function() {
  //   driver.sleep(4000);
  //   driver.findElement({id: "Opportunity"}).getAttribute("value").then(function(opp) {
  //     return expect(opp).to.not.equal("");
  //   });
  //   driver.findElement({id: "contacts"}).sendKeys("a");
  //   driver.findElement({linkText: "Save"}).click();
  //   waitFor({xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"}, "\nCould not create activity");
  //   return driver.sleep(4000);
  // });
  // return it("Check percentage", function() {
  //   driver.get(url + "#/history/opportunities/TDD1");
  //   driver.sleep(1000);
  //   return driver.findElement({xpath: "//div[text()='Rapid Sales']/following-sibling::div[4]"}).getText().then(function(percent) {
  //     return expect(percent).to.be.equal("30%");
  //   });
  //  });
});

describe("Check Opportunities", function() {
  it("Check listing in my territory", function() {
    driver.get(url + "#/myterritory");
    driver.sleep(500)
    waitFor({linkText: "Opportunities"}, "No opportunities button");
    driver.findElement({linkText: "Opportunities"}).click();
    waitFor({xpath: "(//a[div/div[text()='Rapid Sales']])[1]"}, "Could not find opportunity");
    //return driver.sleep(100)
    driver.findElement({xpath: "(//a[div/div[text()='Rapid Sales']])[1]"}).click();
    waitFor({id: "monthlyFee"}, "Opportunity detail screen did not appear");
    return driver.findElement({id: "monthlyFee"}).getAttribute('value').then(function(amount) {
      return expect(amount).to.be.equal("100");
    });
  });
  it("Check opportunity activities", function() {
    driver.sleep(500);
    driver.findElement({linkText: "Activities"}).click();
    return driver.isElementPresent({xpath: "//a[div/div[text()='Cold Call']]"});
  });
  it("Check for checkin activity does not appear", function() {
    driver.findElement({xpath: "//button[@class='selectactivitytype fa fa-plus']"}).click();
    return driver.isElementPresent({xpath: "//a[p[text()='Checkin']]"}).then(function(isPresent) {
      expect(isPresent).to.be["false"];
    });
  });
  return it("Create pipeline activity", function() {
    driver.findElement({xpath: "//a[p[text()='First Meeting']]"}).click();
    driver.findElement({id: "note"}).sendKeys("First meeting went well");
    driver.findElement({id: "Opportunity"}).getAttribute('value').then(function(opp) {
      return expect(opp).to.not.equal("");
    });
    driver.findElement({linkText: "Save"}).click();
    return waitFor({xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"}, "\nCould not create activity");
  });
});

describe("Check navigation in history", function() {
  it("Check activities -> Activity -> activities", function() {
    gocustomer('TDD Customer 1');
    driver.findElement({
      linkText: "History"
    }).click();
    waitFor({
      xpath: "//div[text()='Checkin']"
    }, "Activities did not display");
    driver.findElement({
      xpath: "//div[text()='Checkin']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      linkText: "Back"
    }).click();
    return waitFor({
      xpath: "//div[text()='Checkin']"
    }, "Navigation problem, Activities did not display after back from activity");
  });
  it("Check opportunities -> activities -> NEW -> activities -> opportunities", function() {
    driver.sleep(500);
    driver.findElement({
      xpath: "//button[@class='selectactivitytype']"
    }).click();
    driver.findElement({
      linkText: "Back"
    }).click();
    waitFor({
      xpath: "//div[text()='Checkin']"
    }, "Navigation problem, Activities did not display after back from selectactivitytype");
    driver.findElement({
      xpath: "//button[@class='selectactivitytype']"
    }).click();
    driver.findElement({
      xpath: "//p[text()='First Meeting']"
    }).click();
    driver.findElement({
      linkText: "Back"
    }).click();
    return waitFor({
      xpath: "//div[text()='Checkin']"
    }, "Navigation problem, Activities did not display after back from NEW activity");
  });
  it("Check opportunities -> opportunity -> activities -> opportunity -> opportunities", function() {
    gocustomer('TDD Customer 1');
    driver.findElement({
      linkText: "History"
    }).click();
    waitFor({
      xpath: "//div[text()='Checkin']"
    }, "Activities did not display");
    driver.findElement({
      linkText: "Opportunities"
    }).click();
    waitFor({
      xpath: "//div[text()='Rapid Sales']"
    }, "Rapid Sales Opportunity did not display");
    driver.findElement({
      xpath: "//div[text()='Rapid Sales']"
    }).click();
    waitFor({
      xpath: "//input[@id='name']"
    }, "Rapid Sales opportunity form did not display");
    driver.findElement({
      linkText: "Activities"
    }).click();
    driver.findElement({
      linkText: "Back"
    }).click();
    return waitFor({
      xpath: "//div[text()='Rapid Sales']"
    }, "Navigation problem, opportunities not displayed after clicking on back");
  });
  it("Check opportunities -> opportunity -> activities -> activity -> activities -> opportunity -> opportunities", function() {
    driver.findElement({
      linkText: "Opportunities"
    }).click();
    waitFor({
      xpath: "//div[text()='Rapid Sales']"
    }, "Rapid Sales Opportunity did not display");
    driver.findElement({
      xpath: "//div[text()='Rapid Sales']"
    }).click();
    waitFor({
      xpath: "//input[@id='name']"
    }, "Rapid Sales opportunity form did not display");
    driver.findElement({
      linkText: "Activities"
    }).click();
    waitFor({
      xpath: "//div[text()='First Meeting']"
    }, "Opportunity activities did not appear");
    driver.findElement({
      xpath: "//div[text()='First Meeting']"
    }).click();
    driver.findElement({
      linkText: "Back"
    }).click();
    return waitFor({
      xpath: "//div[text()='First Meeting']"
    }, "Navigation problem, Activities not displayed after clicking on back");
  });
  return it("Check opportunities -> opportunity -> activities -> NEW -> activities -> opportunity -> opportunities", function() {
    driver.sleep(500);
    driver.findElement({
      xpath: "//button[@class='selectactivitytype fa fa-plus']"
    }).click();
    driver.findElement({
      linkText: "Back"
    }).click();
    waitFor({
      xpath: "//div[text()='First Meeting']"
    }, "Navigation problem, Did not go back correctly from selectpipelineactivitytype to opportunity activities");
    driver.findElement({
      xpath: "//button[@class='selectactivitytype fa fa-plus']"
    }).click();
    driver.findElement({
      xpath: "//p[text()='First Meeting']"
    }).click();
    driver.findElement({
      linkText: "Back"
    }).click();
    return waitFor({
      xpath: "//div[text()='First Meeting']"
    }, "Navigation problem, Did not go back correctly from newactivity to opportunity activities");
  });
});

describe("Create call cycle", function() {
  it("Get our week number", function() {
    driver.get(url + "#/today");
    driver.sleep(500);
    return driver.findElement({
      id: "weekn"
    }).getText().then(function(val) {
      global.weekNumber = val;
    });
  });
  it("Goto the correct week", function() {
    driver.findElement({
      linkText: "Edit"
    }).click();
    driver.sleep(500);
    if (global.weekNumber > 1) {
      driver.findElement({
        id: "nextBtn"
      }).click();
    }
    if (global.weekNumber > 2) {
      driver.findElement({
        id: "nextBtn"
      }).click();
    }
    if (global.weekNumber > 3) {
      driver.findElement({
        id: "nextBtn"
      }).click();
    }
    return driver.findElement({
      id: "weektext"
    }).getText().then(function(weekText) {
      return expect(weekText).to.be.equal("Week " + global.weekNumber);
    });
  });
  it("Add 1st customer and click today", function() {
    var day;
    driver.findElement({
      id: "searchbox"
    }).clear();
    driver.findElement({
      id: "searchbox"
    }).sendKeys("TDD");
    driver.sleep(500);
    driver.findElement({
      xpath: "//li[a='TDD Customer 1']"
    }).click();
    driver.findElement({
      id: "addBtn"
    }).click();
    driver.sleep(500);
    day = (new Date).getDay() + 3;
    return driver.findElement({
      xpath: "//table/tbody/tr/td[" + day + "]/span"
    }).click();
  });
  return it("Add 2nd customer, click today and save", function() {
    var day;
    driver.findElement({
      id: "searchbox"
    }).clear();
    driver.findElement({
      id: "searchbox"
    }).sendKeys("TDD");
    driver.sleep(500);
    driver.findElement({
      xpath: "//li[a='TDD Customer 2']"
    }).click();
    driver.findElement({
      id: "addBtn"
    }).click();
    driver.sleep(500);
    day = (new Date).getDay() + 3;
    driver.findElement({
      xpath: "(//table/tbody/tr/td[" + day + "]/span)[2]"
    }).click();
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), 10000, "\nCould not save the call cycle");
  });
});

describe("Check Today Screen", function() {
  it("Expect 2 customers on today screen", function() {
    driver.get(url + "#today");
    driver.sleep(500);
    return driver.isElementPresent({
      xpath: "//h4[text()='TDD Customer 2']"
    });
  });
  return it("Create an activity and check customer is ticked", function() {
    waitFor({
      xpath: "//a[h4[text()='TDD1']]"
    }, "Could not find Customer 1");
    driver.findElement({
      xpath: "//a[h4[text()='TDD2']]"
    }).click();
    waitFor({
      xpath: "//button[@class='selectactivitytype']"
    }, "Could not find + button");
    driver.findElement({
      xpath: "//button[@class='selectactivitytype']"
    }).click();
    waitFor({
      xpath: "//a[p[text()='Checkin']]"
    }, "Could not find checkin activity type");
    driver.findElement({
      xpath: "//a[p[text()='Checkin']]"
    }).click();
    driver.findElement({
      id: "note"
    }).sendKeys("Checking today screen");
    driver.findElement({
      linkText: "Save"
    }).click();
    waitFor({
      xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
    }, "\nCould not create activity");
    driver.findElement({
      linkText: "Back"
    }).click();
    waitFor({
      xpath: "//ul/a"
    }, "could not get back to today screen");
    return driver.isElementPresent({
      xpath: "//a[1]/span[@class='fa fa-check-square-o pull-left']"
    });
  });
});

describe("Check Leaderboard", function() {
  it("Ensure it has remembered our group", function() {
    driver.get(url + "#groups");
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[text()='Joburg reps']"
      });
    }), timeout, "Did not remember our group");
  });
  return it("Check for 1 customer for TDD User on leaderboard", function() {
    driver.findElement({
      linkText: "LeaderBoard"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//td[text()='1']"
      });
    }), timeout, "Did not find the leaderboard with count of 1 customer under activities");
  });
});

describe("Test highlighting of activities", function() {
  return it("Create activity", function() {
    gocustomer('TDD Customer 2');
    driver.findElement({
      xpath: "//button[@class='selectactivitytype']"
    }).click();
    driver.sleep(500);
    driver.findElement({
      xpath: "//a[p='Cold Call'][1]"
    }).click();
    driver.sleep(500);
    driver.findElement({
      id: "note"
    }).sendKeys("Test highlights");
    driver.findElement({
      linkText: "Save"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), 10000, "\nCould not save activity");
    return driver.isElementPresent({
      xpath: "//a[@class='ng-scope list-group-item-success row list-group-item'][contains(.,'Cold Call')]"
    });
  });
});

describe("Day End's", function() {
  it("Day End Procedures", function() {
    var d;
    driver.get(url + "#dayend");
    driver.findElement({
      linkText: "Refresh"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//small[@class='ng-binding cal-events-num badge badge-important pull-left']"
      });
    }), timeout, "Could not find day end results");
    d = (new Date).getDate();
    driver.findElement({
      xpath: "//div[span[@class='pull-right ng-binding']='" + d + "']"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//ul[@class='list-group inset']"
      });
    }), timeout, "\nCould not select date");
  });
  it("Check for error over 100%", function() {
    driver.findElement({
      xpath: "(//input)[1]"
    }).sendKeys("110");
    driver.findElement({
      linkText: "Next"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-danger']"
      });
    }), timeout, "Did not get over 100% error message");
    return driver.sleep(4000);
  });
  it("Check Normal Percentage", function() {
    driver.findElement({
      xpath: "(//input)[1]"
    }).clear();
    driver.findElement({
      xpath: "(//input)[1]"
    }).sendKeys("40");
    driver.findElement({
      linkText: "Next"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//h4[contains(.,'Other')]"
      });
    }), timeout, "Did not get to next screen");
  });
  it("Check for error over 100% error", function() {
    driver.findElement({
      xpath: "(//input[@id='field'])[2]"
    }).sendKeys("400");
    driver.findElement({
      linkText: "Save"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-danger']"
      });
    }), timeout, "Did not get over 100% error message");
    driver.sleep(4000);
    return driver.findElement({
      xpath: "(//input[@id='field'])[2]"
    }).clear();
  });
  it("Check for error to enter Other details", function() {
    driver.findElement({
      id: "Other"
    }).sendKeys("10");
    driver.findElement({
      linkText: "Save"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-danger']"
      });
    }), timeout, "Did not get error to enter a description");
    return driver.sleep(4000);
  });
  it("Checking less than 100% error", function() {
    driver.findElement({
      xpath: "(//input[@id='field'])[2]"
    }).clear();
    driver.findElement({
      xpath: "(//input[@id='field'])[2]"
    }).sendKeys("30");
    driver.findElement({
      id: "Other"
    }).clear();
    driver.findElement({
      id: "Other"
    }).sendKeys("10");
    driver.findElement({
      id: "otherDescription"
    }).sendKeys("Doctor");
    driver.findElement({
      linkText: "Save"
    }).click();
    driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-danger']"
      });
    }), timeout, "Did not get error to enter a description");
    return driver.sleep(4000);
  });
  it("Create total says 100%", function() {
    driver.findElement({
      xpath: "(//input[@id='field'])[3]"
    }).sendKeys("20");
    driver.sleep(500);
    return driver.isElementPresent({
      xpath: "//td[contains(.,'100')]"
    });
  });
  it("Save the day end", function() {
    driver.findElement({
      linkText: "Save"
    }).click();
    return driver.wait((function() {
      return driver.isElementPresent({
        xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"
      });
    }), timeout, "\nCould not create activity");
  });
  return it("Check date is green", function() {
    var d;
    d = (new Date).getDate();
    return driver.wait((function() {
      return driver.findElement({
        xpath: "//div[span[@class='pull-right ng-binding']='" + d + "']/span/small[@class='ng-binding cal-events-num badge badge-green pull-left']"
      });
    }), timeout, "\nCould not create activity");
  });
});

deselectDF = function(cnt) {
  return driver.findElement({
    xpath: "//tr[" + cnt + "]/td[4]/input"
  }).getAttribute("checked").then(function(val) {
    if (val === "true") {
      return driver.findElement({
        xpath: "//tr[" + cnt + "]/td[4]/input"
      }).click();
    }
  });
};

selectDF = function(field, order, label) {
  driver.findElement({id: "visible" + field}).click();
  driver.findElement({id: "sort" + field}).click();
  driver.findElement({id: "sort" + field}).clear();
  driver.findElement({id: "sort" + field}).sendKeys(order);
  if (label !== "") {
    driver.findElement({id: "label" + field}).clear();
    return driver.findElement({id: "label" + field}).sendKeys(label);
  }
};

gocustomer = function(custname) {
  driver.get(url + "#/myterritory");
  driver.sleep(500);
  //driver.findElement({linkText: "Companies"}).click();
  driver.findElement({xpath: "//a[div[text()='" + custname + "']]"}).click();
  return waitFor({id: "Name"}, "Could not find the customer ");
};

newcustomer = function(AccountID, AccountGroup, AccountName, Pricelist) {
  driver.get(url + "#/myterritory");
  driver.findElement({linkText: "Company"}).click();
  driver.sleep(1000);
  driver.findElement({id: "AccountID"}).sendKeys(AccountID);
  driver.findElement({id: "AccountGroup"}).sendKeys(AccountGroup);
  driver.findElement({id: "Name"}).sendKeys(AccountName);
  driver.findElement({id: "Pricelist"}).clear();
  driver.findElement({id: "Pricelist"}).sendKeys(Pricelist);
  driver.findElement({linkText: "Save"}).click();
  return waitFor({xpath: "//div[@class='alert ng-scope top-right am-fade alert-success']"}, "\nFailed to create company");
};

waitFor = function(obj, message) {
  return driver.wait((function() {
    return driver.isElementPresent(obj);
  }), 30000, "\n" + message);
};


/*
 * take a snapshot
 */

screenshot = function(step) {
  return driver.takeScreenshot().then(function(image, err) {
    require('fs').writeFile('out.png', image, 'base64', function(err) {
      console.log(err);
    });
  });
};

// ---
// generated by coffee-script 1.9.2
