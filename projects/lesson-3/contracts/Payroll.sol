pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        address id;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary;
    
    mapping(address => Employee) public employees;
    
    modifier employeeIsExist(address employeeId){
        assert (employees[employeeId].id != 0x0);
        _;
    }
    
    function Payroll() payable public {
        // TODO: your code here
        owner = msg.sender;
    }

    /*Ö§¸¶¹¤×Ê */
    function _particlePaid(Employee employee) private{
        uint payment = employee.salary
                        .mul(now.sub(employee.lastPayDay)) 
                        .div(payDuration);
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) public {
        // TODO: your code here
        uint salaryTemp = salary * 1 ether;
        employees[employeeId] = Employee(employeeId,salaryTemp,now);
        totalSalary += salaryTemp;
    }

    function checkEmployee(address employeeAddress) public employeeIsExist(employeeAddress) returns (uint salary, uint lastPayDay,address sender) {
        Employee employee = employees[employeeAddress];
        salary = employee.salary;
        lastPayDay = employee.lastPayDay;
        sender = msg.sender;
    }

    function removeEmployee(address employeeId) public onlyOwner() employeeIsExist(employeeId) {
        // TODO: your code here
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner() employeeIsExist(employeeId) {
        // TODO: your code here
        Employee e = employees[employeeId];
        
        _particlePaid(e);
        
        totalSalary -= e.salary;
        e.lastPayDay = now;
        e.id = employeeId;
        e.salary = salary * 1 ether;
        
        totalSalary += salary;
    }
    
    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        require(totalSalary > 0);

        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway() > 0;
    }

    function getPaid() public employeeIsExist(msg.sender) {
        // TODO: your code here
        Employee storage employeeTemp = employees[msg.sender];

        uint nextPayDay = employeeTemp.lastPayDay + payDuration;

        assert (nextPayDay <= now);

        employeeTemp.lastPayDay = nextPayDay;

        employeeTemp.id.transfer(employeeTemp.salary);
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner() employeeIsExist(oldAddress) {
        // TODO: your code here
        Employee oldE = employees[oldAddress];
        
        _particlePaid(oldE);
        
        oldE.lastPayDay = now;
        oldE.id = newAddress;
        employees[newAddress] = oldE;
        delete employees[oldAddress];
    }
}
