var Payroll = artifacts.require("Payroll");

contract('Payroll', function (accounts) {

    var owner = accounts[0];

    var employee = accounts[1];

    xit('should run', function () {
        var payroll;
        Payroll.deployed().then(function (instance) {
            payroll = instance;
            payroll.addEmployee(employee, 1);
        }).then(function () {
            payroll.addFund.call(owner, {from: owner, value: web3.toWei(30, 'ether')})
            //     .then(() => {
            //     return payroll.calculateRunway();
            // }).then(runway => {
            //     assert.equal(runway, 30, "runway should beo 30 / 1");
            // });
        })
    });
});