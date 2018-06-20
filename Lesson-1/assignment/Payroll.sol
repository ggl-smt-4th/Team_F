// notice: Input address param must add ""

pragma solidity ^0.4.14;

 
contract Payroll {
    struct Salary {
        string name;
        address addr;
        uint salary;
        uint lastPayDate;
    }
    mapping(address => Salary) employees;
    address owner;
    uint totalSalary = 0;
    uint constant payDuration = 10 seconds;
    
    // constructor
    // call when contract deploy, only run once
    function Payroll() payable {
        owner = msg.sender;
    }
    
    // add emplyee
    function addEmployee(address addr, string name, uint salary) returns (bool) {
        require(msg.sender == owner);
        
        employees[addr].name = name;
        employees[addr].addr = addr;
        employees[addr].salary = salary;
        employees[addr].lastPayDate = now;
        totalSalary += salary;
        return true;
    }
    
    // update emplyee's address
    function updateEmployeeAddr(address oldAddr, address newAddr) {
        if(msg.sender != owner || oldAddr != employees[oldAddr].addr) {
            revert();
        }
        
        employees[newAddr] = employees[oldAddr];
        employees[newAddr].addr = newAddr;

        delete employees[oldAddr];
    }
    
    // update employee salary
    // notice: We must pay all to emplyee before update new salary
    function updateEmployeeSalary(address emplyee, uint newSalary) returns (uint pay){
        if(msg.sender != owner || emplyee != employees[emplyee].addr) {
            revert();
        }
        
        uint payDate = now - employees[emplyee].lastPayDate;
        uint salary = employees[emplyee].salary * (payDate / payDuration);
        
        totalSalary -= employees[emplyee].salary;
        totalSalary += newSalary; 
        employees[emplyee].salary = newSalary;
        employees[emplyee].lastPayDate = now;
        
        employees[emplyee].addr.transfer(salary);
        
        return salary;
    }
    
    // get emplyee's name
    function getEmployee (address emplyee) constant returns (string name) {
        require(msg.sender == owner);
        
        return employees[emplyee].name;
    }
    
    // del emplyee
    // notice: We must pay all to emplyee before delete him
    function delEmployee(address emplyee) returns (uint pay){
        require(msg.sender == owner);
        
        uint payDate = now - employees[emplyee].lastPayDate;
        uint salary = employees[emplyee].salary * (payDate / payDuration);
        totalSalary -= employees[emplyee].salary;
        employees[emplyee].addr.transfer(salary);
        delete employees[emplyee];
        
        return salary;
    }
    
    // add Foud
    function addFund() payable returns (uint) {
        return address(this).balance;
    }

    // calculate Run way
    function calculateRunway() returns (uint) {
        return address(this).balance / totalSalary;
    }
    
    // Is this contract's foud engouh to pay all employee's salay
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    // employee get salary
    function getPaid() {
        if(msg.sender != employees[msg.sender].addr) {
            revert();
        }
        
        uint payDate = employees[msg.sender].lastPayDate + payDuration;
        if(payDate > now) {
            revert();
        }
        
        employees[msg.sender].lastPayDate = payDate;
        msg.sender.transfer(employees[msg.sender].salary);
    }
}

