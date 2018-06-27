pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    address owner;
    uint payDuration = 30 days;

    struct Employee {
        uint salary;
        uint lastPayday;
        bool registered;
    }

    // use a mapping to store employees' information
    mapping(address => Employee) employees;

    uint totalSalary = 0;

    constructor() payable public {
        owner = msg.sender;
    }

    modifier employeeRegistered(address employeeAddress) {
        assert(employees[employeeAddress].registered);
        _;
    }

    function _partialPaid(address employeeAddress) private {
        uint payment = employees[employeeAddress].salary.mul(
            (now.sub(employees[employeeAddress].lastPayday)).div(payDuration));
        employeeAddress.transfer(payment);
    }

    function addEmployee(address employeeAddress, uint salary) public onlyOwner{
        // check whether the employee has already been added
        require(!employees[employeeAddress].registered && employeeAddress != 0x0);
        employees[employeeAddress].salary = salary.mul(1 ether);
        employees[employeeAddress].lastPayday = now;
        employees[employeeAddress].registered = true;
        // update totalSalary
        totalSalary = totalSalary.add(salary.mul(1 ether));
    }

    function removeEmployee(address employeeAddress) public onlyOwner employeeRegistered(employeeAddress) {
        employees[employeeAddress].registered = false;
        _partialPaid(employeeAddress);
        // update totalSalary
        totalSalary = totalSalary.sub(employees[employeeAddress].salary);
        delete employees[employeeAddress];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner employeeRegistered(oldAddress) {
        require(newAddress != 0x0);
        employees[oldAddress].registered = false;
        employees[newAddress] = employees[oldAddress];
        delete employees[oldAddress];
        employees[newAddress].registered = true;
    }

    function updateEmployee(address employeeAddress, uint newSalary) public onlyOwner employeeRegistered(employeeAddress) {
        uint oldSalary = employees[employeeAddress].salary;
        _partialPaid(employeeAddress);
        // update salary and lastPayday
        employees[employeeAddress].salary = newSalary.mul(1 ether);
        employees[employeeAddress].lastPayday = now;
        // update totalSalary
        totalSalary = totalSalary.sub(oldSalary).add(newSalary.mul(1 ether));
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeRegistered(msg.sender) {
        address employeeAddress = msg.sender;
        uint nextPayday = employees[employeeAddress].lastPayday.add(payDuration);
        assert(nextPayday < now);
        employees[employeeAddress].lastPayday = now;
        employeeAddress.transfer(employees[employeeAddress].salary);
    }
}
