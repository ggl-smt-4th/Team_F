var Payroll = artifacts.require('Payroll');

contract('Payroll', function (accounts) {
    var owner = accounts[0];

    var employee = accounts[1];
    var employee2 = accounts[2];

    var guest = accounts[5];

    xit('owner should be able to remove employee', function () {
        var payroll;

        Payroll.new().then(function (instance) {
            payroll = instance;
            instance.addFund({from: owner, value: web3.toWei(30, 'ether')});
        })
            .then(function () {
            payroll.addEmployee(employee, 1, {from: owner});
        })
            .then(function () {
            payroll.removeEmployee(employee, {from: owner, gas: 2000000000000});
        })
            .then(function () {
            assert(true, 'add employee should succeeded');
        })
    });

    xit('non owner should not be able to remove employee', function () {
        var payroll;

        Payroll.new().then(function (instance) {
            payroll = instance;
            instance.addFund({from: owner, value: web3.toWei(30, 'ether')});
        })
            .then(function () {
                return payroll.addEmployee(employee, 1, {from: owner});
            })
            .then(function () {
                return payroll.removeEmployee(employee, {from: guest});
            })
            .then(function () {
                assert(false, 'remove employee by guest should fail');
            })
    });

    it("Test call removeEmployee() by owner", () => {
        // Remove employee
        var localPayroll;
        Payroll.new().then(instance => {
            localPayroll = instance;
            return localPayroll.addEmployee(employee, 1, {from: owner});
        }).then(function () {
            localPayroll.removeEmployee(employee, {from: owner});
        });
    });
});