pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {

    struct Employee {
        address id;
        uint salary;
        uint lastPayDate;
    }
    mapping(address => Employee) public employees;

    uint constant payDuration = 31 days;
    uint totalSalary = 0;

    constructor() payable public {}

	function _payOffSalary(Employee employee) private {
	    uint allSalary = SafeMath.mul(employee.salary, now - employee.lastPayDate) / payDuration;
	    assert(address(this).balance >= allSalary);

        employee.id.transfer(allSalary);
	}

    function addEmployee(address employeeAddress, int salary) onlyOwner public {
        assert(salary > 0);
        assert(employees[employeeAddress].id == 0x0);
        
        employees[employeeAddress] = Employee(employeeAddress, (uint)(salary) * 1 ether, now);
        totalSalary = SafeMath.add(totalSalary, (uint)(salary) * 1 ether);
    }

    function removeEmployee(address employeeAddress) onlyOwner public {
        var employee = employees[employeeAddress];
	    assert(employee.id != 0x0);
	    
	    _payOffSalary(employee);
	    
	    totalSalary = SafeMath.sub(totalSalary, employee.salary);
	    delete employees[employeeAddress];
    }

    function updateEmployee(address employeeAddress, uint salary) onlyOwner public {
        var employee = employees[employeeAddress];
	    assert(employee.id != 0x0);
	    
	    totalSalary = SafeMath.add( SafeMath.sub(totalSalary, employee.salary), salary * 1 ether );
	    _payOffSalary(employee);
	    
	    employee.salary = salary * 1 ether;
	    employee.lastPayDate = now;
    }
    
    function changePaymentAddress(address oldPayAddr, address newPayAddr) onlyOwner public {
        var employee = employees[oldPayAddr];
	    assert(employee.id != 0x0);
	    
        employees[newPayAddr].id = newPayAddr;
        employees[newPayAddr].salary = employee.salary;
        employees[newPayAddr].lastPayDate = employee.lastPayDate;
	    
	    delete employees[oldPayAddr];
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        assert(totalSalary > 0);
    
    	return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var employee = employees[msg.sender];
	    assert(employee.id != 0x0);

	    uint payDate = SafeMath.add(employee.lastPayDate, payDuration);
	    assert(now > payDate);
	    
	    employee.lastPayDate = payDate;

        assert(address(this).balance >= employee.salary);
	    employee.id.transfer(employee.salary);    
    }
}
