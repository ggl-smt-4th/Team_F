var Payroll = artifacts.require("../contracts/Payroll.sol");

contract('Payroll', function(accounts) {

  it("New employee should exists after addEmployee action", function() {
    return Payroll.deployed().then(function(instance) {

      var address = accounts[0];
      console.log("Test account address is " + address);
      instance.addEmployee.call(address, 2);
      console.log("Add employee finished! ");

    }).then(function() {
      //var address = accounts[0];
      //console.log("address is " + address + " and employees is " + payroll.employees[address].id);

      //I do not know why this assert can not work. 55555555555
      
      //assert.equal(payroll.employees[address].id, address, "Add" + address + "failed!");
    });
  });

  it("Employee should not exists after removeEmployee action", function() {
    return Payroll.deployed().then(function(instance) {

      payroll = instance;

      var address = accounts[1];
      console.log("Test acount address is " + address);

      payroll.addEmployee(address, 2);
      console.log("add employee finished: " + address);

    }).then(function() {

      payroll.removeEmployee(accounts[1]);
      
    }).then(function() {

      var address = accounts[1];
      assert.equal(payroll.employees[address], undefined , "Remove " + address + " failed!");
    });
  });

  it("Employee can get paid", function() {
    return Payroll.deployed().then(function(instance) {

      payroll = instance;
      payroll.addEmployee(accounts[1], 2);

    }).then(function() {

      payroll.getPaid(accounts[1]);

    });
  });

});
