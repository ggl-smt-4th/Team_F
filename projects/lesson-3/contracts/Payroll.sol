pragma solidity ^0.4.14;

contract Payroll {

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

    modifier validSalary(int salary) {
        require (salary >= 0);
        _;
    }

    function addEmployee(address employeeAddress, int salary) public validSalary(salary) ownerOnly {

        uint salaryInEther = uint(salary) * 1 ether;
        employees[employeeAddress] = Employee(employeeAddress, salaryInEther, now);

        totalSalary += salaryInEther;

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

        totalSalary -= employee.salary;
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

    function updateEmployee(address employeeAddress, int salary) public validSalary(salary) ownerOnly employeeExist
    (employeeAddress) {

        Employee employee = employees[employeeAddress];

        uint salaryInETH = uint(salary) * 1 ether;
        assert (employee.salary != salaryInETH);

        uint lastSalary = employee.salary;

        employee.salary = salaryInETH;

        uint remainingPayDay = (now - employee.lastPayDay);

        employee.lastPayDay = now;

        totalSalary += salaryInETH - lastSalary;

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

