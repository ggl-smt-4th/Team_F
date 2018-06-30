var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[5];
  const salary = 1;

  let payroll;

  beforeEach("Setup contract for each test cases", () => {
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

  it("Test removeEmployee() by guest", () => {
      return payroll.removeEmployee(employee, {from: guest})
      .then(() => {  // success
        assert(false, "Should not be successful");
      }).catch(error => {  // failed
        assert.include(error.toString(), "Error: VM Exception", "Can not removeEmployee() by guest");
      });
  });

  it("Test removeEmployee() by owner", () => {
      return payroll.removeEmployee(employee, {from: owner});
  });

  it("Test removeEmployee(), remove the same employee multiple time (also mean: remove someone is not employee)", () => {
      payroll.removeEmployee(employee, {from: owner});
      return payroll.removeEmployee(employee, {from: owner})
      .then(() => {  // success
        assert(false, "Should not be successful");
      }).catch(error => {  // failed
        assert.include(error.toString(), "Error: VM Exception", "Can not removeEmployee() that someone is not employee");
      });
  });


});
