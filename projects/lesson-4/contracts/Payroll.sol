pragma solidity ^0.4.14;
import "./SafeMath.sol";

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 1 seconds;
    uint totalSalary = 0;

    address owner;
    mapping(address => Employee) public employees;

    constructor() payable public {
        owner = msg.sender;
    }

    modifier onlyOwer() {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyEmployee() {
        require(msg.sender != owner);
        _;
    }
    
    modifier employeeExist(address _address) {
        Employee storage _employee = employees[_address];
        assert(_employee.id != 0x0);
        _;
    }

    function _partialPaid(address employeeId) private {
        uint payment = SafeMath.div(SafeMath.mul(employees[employeeId].salary, SafeMath.sub(now, employees[employeeId].lastPayday)), payDuration);
        employees[employeeId].lastPayday = now;
        employeeId.transfer(payment);
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwer employeeExist(oldAddress) {
        Employee storage employee = employees[oldAddress];
        employee.id = newAddress;
        employees[newAddress] = employee;
        
        delete employees[oldAddress]; 
    }

    function addEmployee(address employeeAddress, uint salary) public onlyOwer {
        
        salary = SafeMath.mul(salary, 1 ether);
        employees[employeeAddress] = Employee(employeeAddress, salary, now);

        totalSalary= SafeMath.add(totalSalary, salary);
    }

    function removeEmployee(address employeeId) public onlyOwer employeeExist(employeeId) {
        
        _partialPaid(employeeId);
        uint salary = employees[employeeId].salary;
        
        totalSalary= SafeMath.sub(totalSalary, salary);
        delete employees[employeeId];
    }

    function updateEmployee(address employeeAddress, uint salary) public onlyOwer employeeExist(employeeAddress) {

        _partialPaid(employeeAddress);

        uint oldSalary = employees[employeeAddress].salary;
        salary = SafeMath.mul(salary, 1 ether);
        employees[employeeAddress].salary = salary;
        employees[employeeAddress].lastPayday = now;

        totalSalary= SafeMath.sub(totalSalary, oldSalary);
        totalSalary= SafeMath.add(totalSalary, salary);
    }

    function addFund() payable public onlyOwer returns (uint)  {
        return address(this).balance;
    }

    function calculateRunway() public onlyOwer view returns (uint) {
        require(totalSalary > 0);
        return SafeMath.div(address(this).balance, totalSalary);
    }

    function hasEnoughFund() public onlyOwer view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public onlyEmployee employeeExist(msg.sender) {
        
        address employeeAddress = msg.sender;
        Employee storage employee = employees[employeeAddress];
        
        uint nextPayday = SafeMath.add(employee.lastPayday, payDuration);
        require(nextPayday < now);

        employee.lastPayday = nextPayday;
        employeeAddress.transfer(employee.salary);
    }
}

