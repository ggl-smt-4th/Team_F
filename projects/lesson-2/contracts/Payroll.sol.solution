pragma solidity ^0.4.14;

contract Payroll {

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

    function _partialPaid(address employeeAddress) private {
        uint payment = employees[employeeAddress].salary * (now - employees[employeeAddress].lastPayday) / payDuration;
        employeeAddress.transfer(payment);
    }

    function addEmployee(address employeeAddress, uint salary) public {
        // check whether the employee has already been added
        require(owner == msg.sender && !employees[employeeAddress].registered);
        employees[employeeAddress].salary = salary * 1 ether;
        employees[employeeAddress].lastPayday = now;
        employees[employeeAddress].registered = true;
        // update totalSalary
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeAddress) public {
        // check whether the employee has already been added
        require(owner == msg.sender && employees[employeeAddress].registered);
        employees[employeeAddress].registered = false;
        _partialPaid(employeeAddress);
        // update totalSalary
        totalSalary -= employees[employeeAddress].salary;
    }

    function updateEmployee(address employeeAddress, uint newSalary) public {
        // update salary only if the employee is registered
        require(owner == msg.sender && employees[employeeAddress].registered);
        uint oldSalary = employees[employeeAddress].salary;
        _partialPaid(employeeAddress);
        // update salary and lastPayday
        employees[employeeAddress].salary = newSalary * 1 ether;
        employees[employeeAddress].lastPayday = now;
        // update totalSalary
        totalSalary = totalSalary - oldSalary + newSalary * 1 ether;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        require(employees[msg.sender].registered);
        address employeeAddress = msg.sender;
        uint nextPayday = employees[employeeAddress].lastPayday + payDuration;
        assert(nextPayday < now);
        employees[employeeAddress].lastPayday = now;
        employeeAddress.transfer(employees[employeeAddress].salary);
    }
}
