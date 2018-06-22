pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        // TODO: your code here
        address id;
        uint salary;
        uint lastPayDate;
    }

    uint constant payDuration = 30 days;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

	function _findEmployee(address employeeID)  private returns (Employee, uint) {
	    for(uint i = 0; i < employees.length; i++) {
	        if(employees[i].id == employeeID)
	            return (employees[i], i);
	    }
	}

	function _payOffSalary(Employee employee) private {
	    uint nPay = employee.salary * (now - employee.lastPayDate) / payDuration;
	    employee.id.transfer(nPay);
	}


    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee, index) = _findEmployee(employeeAddress);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeAddress, salary * 1 ether, now));
        totalSalary += salary * 1 ether;        
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee, index) = _findEmployee(employeeId);
	    assert(employee.id != 0x0);
	    
	    _payOffSalary(employee);
	    
	    totalSalary = totalSalary - employee.salary;
	    delete employees[index];
	    employees[index] = employees[employees.length - 1];
	    employees.length -= 1;       
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee, index) = _findEmployee(employeeAddress);
	    assert(employee.id != 0x0);
	    
	    totalSalary = totalSalary - employee.salary + salary * 1 ether;
	    _payOffSalary(employee);
	    employees[index].salary = salary * 1 ether;
	    employees[index].lastPayDate = now;
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
        var (employee, index) = _findEmployee(msg.sender);
	    assert(employee.id != 0x0);

	    uint payDate = employee.lastPayDate + payDuration;
	    assert(now > payDate);
	    
	    employees[index].lastPayDate = payDate;
	    employees[index].id.transfer(employees[index].salary);    
    }
}
