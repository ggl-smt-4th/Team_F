pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    mapping(address => Employee) employees;

    function Payroll() payable public {
    }

    // make sure employeeId is in employees
    modifier isEmployee(address employeeId) {
        require(employees[employeeId].id != 0x0);
        _;
    }

    // make sure employeeId is not in employees
    modifier notEmployee(address employeeId) {
        require(employees[employeeId].id == 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint unpaidSalary = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(unpaidSalary);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner notEmployee(employeeId) {
        require(salary > 0);
        uint salaryInEther = SafeMath.mul(salary, 1 ether);
        totalSalary = SafeMath.add(totalSalary, salaryInEther);
        employees[employeeId] = Employee(employeeId, salaryInEther, now);
    }

    function removeEmployee(address employeeId) public onlyOwner isEmployee(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = SafeMath.sub(totalSalary, employee.salary);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner isEmployee(oldAddress) notEmployee(newAddress) {
        var employee = employees[oldAddress];
        employee.id = newAddress;
        employees[newAddress] = employee;
        delete employees[oldAddress];  // delete must be last
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner isEmployee(employeeId) {
        require(salary > 0);
        var employee = employees[employeeId];
        uint salaryInEther = SafeMath.mul(salary, 1 ether);
        totalSalary = SafeMath.sub(totalSalary, employee.salary);
        _partialPaid(employee);
        totalSalary = SafeMath.add(totalSalary, salaryInEther);
        employee.salary = salaryInEther;
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

    function getPaid() public isEmployee(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayDay = SafeMath.add(employee.lastPayDay, payDuration);
        require(nextPayDay < now);
        employee.lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}
