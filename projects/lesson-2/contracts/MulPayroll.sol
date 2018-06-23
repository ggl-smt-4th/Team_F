pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _findEmployee(address employeeAddress)  private returns (Employee, uint) {
	    for(uint i = 0; i < employees.length; i++) {
	        if(employees[i].id == employeeAddress)
	            return (employees[i], i);
	    }
	}

    function _addSalary() public returns (uint) {
        for (uint i; i < employees.length; i++) {
            totalSalary += employees[i].salary;
            return totalSalary;
        }
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);

        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeAddress) {
                revert();
            }
        }
        employees.push(Employee(employeeAddress, salary, now));
    }

    function removeEmployee(address employeeAddress) public {
        require(msg.sender == owner);

        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeAddress) {
                uint payment = employees[i].salary * 1 ether * (now - employees[i].lastPayday) / payDuration;
                employees[i].id.transfer(payment);
                delete employees[i];
                employees[i] = employees[employees.length - 1];
                employees.length -= 1;
                return;
            }
        }
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);

        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeAddress) {
                uint payment = employees[i].salary * 1 ether * (now - employees[i].lastPayday) / payDuration;
                employees[i].id.transfer(payment);

                employees[i].id = employeeAddress;
                employees[i].salary = salary;
                employees[i].lastPayday = now;
            }
        }
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        uint payment = employees[index].salary * 1 ether;
        employees[index].id.transfer(payment);
    }
}
