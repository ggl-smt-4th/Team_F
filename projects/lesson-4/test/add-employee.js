var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[5];
  const salary = 1;

  it("Test addEmployee() by guest", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: guest});
    }).then(() => {  // success
      assert(false, "Should not be successful");
    }).catch(error => {  // failed
      assert.include(error.toString(), "Error: VM Exception", "Can not addEmployee() by guest");
    });
  });

  it("Test addEmployee() by owner", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

  it("Test addEmployee(), add the same employee multiple time (also mean: add someone already is employee)", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      payroll.addEmployee(employee, salary, {from: owner});
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {  // success
      assert(false, "Should not be successful");
    }).catch(error => {  // failed
      assert.include(error.toString(), "Error: VM Exception", "Can not addEmployee() that someone already is employee");
    });
  });

  it("Test addEmployee() with negative salary", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, -salary, {from: owner});
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Negative salary can not be accepted!");
    });
  });


});
