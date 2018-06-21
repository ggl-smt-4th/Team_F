pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address owner;
    address employee;
    uint salary = 1 ether;
    uint lastPayday;

    function Payroll() payable public {
        owner = msg.sender;
        lastPayday = now;
    }

    function updateEmployeeAddress(address newAddress) public {
        // Only the owner is allowed to set employee address.
        require(msg.sender == owner);

        // Update only if new address is different from the existing one
        if (employee != 0x0) {
            require(employee != newAddress);
        }

        // Assumption: the owner need to pay out unpaid salary
        // to existing employee address before updating the address.
        if (employee != 0x0) {
            require(hasEnoughFund());
            uint unpaidSalary = (now - lastPayday) / payDuration * salary;
            employee.transfer(unpaidSalary);
        }

        lastPayday = now;
        employee = newAddress;
    }

    function updateEmployeeSalary(uint newSalary) public {
        // Only the owner is allowed to set employee salary.
        require(msg.sender == owner);

        // Update only if new salary is different from the existing one
        require(salary != newSalary);

        require(newSalary > 0);
        newSalary = newSalary * 1 ether;

        // Assumption: the owner need to pay out unpaid salary
        // to existing employee address before updating the salary.
        if (employee != 0x0) {
            require(hasEnoughFund());
            uint unpaidSalary = (now - lastPayday) / payDuration * salary;
            employee.transfer(unpaidSalary);
        }

        lastPayday = now;
        salary = newSalary;
    }

    function getEmployee() view public returns (address) {
        return employee;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() view public returns (uint) {
        return address(this).balance / salary;
    }

    function getSalary() view public returns (uint) {
        return salary;
    }

    function getBalance() view public returns (uint) {
        return address(this).balance;
    }

    function hasEnoughFund() view public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // Only employee can get paid.
        require(msg.sender == employee);

        // Check there is enough fund.
        require(hasEnoughFund());

        // Check the payment is already due.
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
