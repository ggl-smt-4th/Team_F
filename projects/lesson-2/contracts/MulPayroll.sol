pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _addSalary() returns (uint) {
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
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
       for (uint i = 0; i < employees.length; i++) {
           if (msg.sender == employees[i].id) {
               uint nextPayday = employees[i].lastPayday + payDuration;
               assert(nextPayday < now);

               employees[i].lastPayday = nextPayday;
               employees[i].id.transfer(employees[i].salary * 1 ether);
           }
       }
    }
}
