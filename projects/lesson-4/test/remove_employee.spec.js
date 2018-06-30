const Payroll = artifacts.require('Payroll');

contract('Payroll', function (accounts) {
    const owner = accounts[0];

    const employee = accounts[1];
    const employee2 = accounts[2];

    const guest = accounts[5];

    it('owner should be able to remove employee', function () {
        let payroll;

        return Payroll.new().then(function (instance) {
            payroll = instance;
            return instance.addFund({from: owner, value: web3.toWei(2, 'ether')});
        })
            .then(function () {
            return payroll.addEmployee(employee, 1, {from: owner});
        })
            .then(function () {
            return payroll.removeEmployee(employee, {from: owner});
        })
            .then(function () {
            assert(true, 'add employee should succeeded');
        }).catch(error => {
                assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by guest");
            });
    });

    it('non owner should not be able to remove employee', function () {
        let payroll;

        return Payroll.new().then(function (instance) {
            payroll = instance;
            return instance.addFund({from: owner, value: web3.toWei(2, 'ether')});
        })
            .then(function () {
                return payroll.addEmployee(employee, 1, {from: owner});
            })
            .then(function () {
                return payroll.removeEmployee(employee, {from: guest});
            })
            .then(function () {
                assert(false, 'remove employee by guest should fail');
            }).catch(error => {
                assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by guest");
            });
    });

    it('should not remove non-exist employee', function () {

        let payroll;

        return Payroll.new().then(function (instance) {
            payroll = instance;
            return instance.addFund({from: owner, value: web3.toWei(2, 'ether')});
        })
            .then(function () {
                return payroll.addEmployee(employee, 1, {from: owner});
            })
            .then(function () {
                return payroll.removeEmployee(employee2, {from: owner});
            })
            .then(function () {
                assert(false, 'remove employee by guest should fail');
            }).catch(error => {
                assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by guest");
            });
    });

});