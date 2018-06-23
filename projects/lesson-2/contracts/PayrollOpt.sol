pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;
    uint totalSalary;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++) {
            if(employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function _partialPaid(Employee employee) private {
        uint unpaidSalary = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(unpaidSalary);
    }

    function addEmployee(address employeeId, uint salary) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);

        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        _partialPaid(employee);
        totalSalary -= employee.salary * 1 ether;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeId, uint salary) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        _partialPaid(employee);
        totalSalary -= employee.salary * 1 ether;
        totalSalary += salary * 1 ether;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
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

    function getPaid() public payable {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayDay = employee.lastPayday + payDuration;
        assert(now > nextPayDay);

        employees[index].lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}

