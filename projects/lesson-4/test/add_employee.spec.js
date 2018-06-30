var Payroll = artifacts.require("Payroll");

contract('Payroll', function (accounts) {

    const owner = accounts[0];

    const employee = accounts[1];

    const guest = accounts[2];

    it('should run', function () {
        let payroll;
        Payroll.new().then(function (instance) {
            payroll = instance;
            payroll.addEmployee(employee, 1);
        }).then(function () {
            payroll.addFund({from: owner, value: web3.toWei(2, 'ether')});
        }).then(() => {
            return payroll.calculateRunway();
        }).then(runway => {
            assert.equal(runway, 2, "runway should beo 30 / 1");
        });
    });

    it('addEmployee should reject illegal salary', function () {
        let payroll;
        Payroll.new().then(function (instance) {
            payroll = instance;
            payroll.addEmployee(employee, -1);
        }).then(() => {
            assert(false, "adding employee with illegal salary should fail!");
        })
    });

    it("guest should fail to call addEmployee", function () {
        let payroll;
        Payroll.new().then(function (instance) {
            payroll = instance;
            payroll.addEmployee(employee, 1, {from: guest});
        }).then(() => {
            assert(false, "adding employee with illegal salary should fail!");
        })
    });

    it("employee should fail to call addEmployee", function () {
        let payroll;
        Payroll.new().then(function (instance) {
            payroll = instance;
            payroll.addEmployee(employee, 1, {from: employee});
        }).then(() => {
            assert(false, "adding employee with illegal salary should fail!");
        })
    });
});