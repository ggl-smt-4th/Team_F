pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 31 days;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        
        employees.push(Employee(employeeAddress, salary * 1 ether, now));
        
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployeeWithAddress(employeeId);


        assert (employee.id != 0x0);
        
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;

    }

    function _findEmployeeWithAddress (address employeeAddress) private returns(Employee, uint)  {
        for (uint i=0; i < employees.length; i++) {
            if (employees[i].id == employeeAddress) {
                return (employees[i], i);
            }
        }
    }
    

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployeeWithAddress(employeeAddress);

        assert (employee.id != 0x0);

        uint salaryInETH = salary * 1 ether;
        assert (employees[index].salary != salaryInETH);
        
        uint lastSalary = employees[index].salary;

        employees[index].salary = salaryInETH;

        uint remainingPayDay = (now - employees[index].lastPayDay);

        employees[index].lastPayDay = now;

        if (remainingPayDay > 0) {
            employees[index].id.transfer(remainingPayDay / payDuration * lastSalary);
        }
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        uint totalSalary = 0;
        for (uint i=0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }

        assert (totalSalary > 0);

        return this.balance / totalSalary;
        
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (employee, index) = _findEmployeeWithAddress(msg.sender);

        assert (employee.id != 0x0);

        uint nextPayDay = employee.lastPayDay + payDuration;
        bool shouldPayNow = now >= nextPayDay;

        assert (shouldPayNow);
        
        employees[index].lastPayDay = nextPayDay;

        employee.id.transfer(employee.salary);

    }
}

