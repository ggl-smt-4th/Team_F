pragma solidity ^0.4.14;

import './SafeMath.sol';

contract Payroll {

    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 30 days;

    uint totalSalary;

    address owner;
    mapping(address => Employee) public employees;

    function Payroll() payable public {
        owner = msg.sender;
        totalSalary = 0;
    }

    modifier validSalary(uint salary) {
        SafeMath.mul(salary, 1 ether);
        _;
    }

    function addEmployee(address employeeAddress, uint salary) public validSalary(salary) ownerOnly {

        uint salaryInWei = salary.mul(1 ether);
        employees[employeeAddress] = Employee(employeeAddress, salaryInWei, now);

        totalSalary = SafeMath.add(totalSalary, salaryInWei);

    }

    function checkEmployee(address employeeAddress) public employeeExist(employeeAddress) returns (uint salary, uint lastPayDay) {
        Employee employee = employees[employeeAddress];
        salary = employee.salary;
        lastPayDay = employee.lastPayDay;
    }

    function changePaymentAddress(address oldAddress, address newAddress) public ownerOnly employeeExist(oldAddress) {
        Employee oldEmployee = employees[oldAddress];
        oldEmployee.id = newAddress;
        employees[newAddress] = oldEmployee;
        delete employees[oldAddress];
    }

    function removeEmployee(address employeeId) public ownerOnly employeeExist(employeeId) {

        Employee employee = employees[employeeId];

        totalSalary = totalSalary.sub(employee.salary);
        assert (employee.id != 0x0);

        delete employees[employeeId];

    }

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    modifier employeeExist (address employeeAddress) {
        assert (employees[employeeAddress].id != 0x0);
        _;
    }

    function updateEmployee(address employeeAddress, uint salary) public validSalary(salary) ownerOnly employeeExist
    (employeeAddress) {

        Employee employee = employees[employeeAddress];

        uint salaryInWei = salary.mul(1 ether);
        assert (employee.salary != salaryInWei);

        uint lastSalary = employee.salary;

        employee.salary = salaryInWei;

        uint remainingPayDay = (now - employee.lastPayDay);

        employee.lastPayDay = now;

        totalSalary = totalSalary.add(salaryInWei).sub(lastSalary);

        if (remainingPayDay > 0) {
            employee.id.transfer(remainingPayDay / payDuration * lastSalary);
        }
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {

        require(totalSalary > 0);

        return address(this).balance / totalSalary;

    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender) {
        Employee storage employee = employees[msg.sender];

        uint nextPayDay = employee.lastPayDay + payDuration;
        bool shouldPayNow = now >= nextPayDay;

        assert (shouldPayNow);

        employee.lastPayDay = nextPayDay;

        employee.id.transfer(employee.salary);

    }
}

