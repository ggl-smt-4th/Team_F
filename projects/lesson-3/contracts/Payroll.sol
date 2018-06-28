pragma solidity ^0.4.14;

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

    function Payroll() payable public {
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
        var _employee = employees[_address];
        assert(_employee.id != 0x0);
        _;
    }

    function _partialPaid(address employeeId) private {
        uint payment = employees[employeeId].salary * (now - employees[employeeId].lastPayday) / payDuration;
        employees[employeeId].lastPayday = now;
        employeeId.transfer(payment);
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwer {
        _partialPaid(oldAddress);
        employees[oldAddress].id = newAddress;
    }

    function addEmployee(address employeeAddress, uint _salary) public onlyOwer {
        
        uint amount = _salary * 1 ether;
        employees[employeeAddress] = Employee(employeeAddress, amount, now);

        totalSalary += amount;
    }

    function removeEmployee(address employeeId) public onlyOwer employeeExist(employeeId) {
        
        _partialPaid(employeeId);
        uint salary = employees[employeeId].salary;
        
        delete employees[employeeId];
        totalSalary -= salary;
    }

    function updateEmployee(address employeeAddress, uint _salary) public onlyOwer {

        _partialPaid(employeeAddress);

        uint oldSalary = employees[employeeAddress].salary;
        uint amount = _salary * 1 ether;
        employees[employeeAddress].salary = _salary;
        employees[employeeAddress].lastPayday = now;

        totalSalary -= oldSalary;
        totalSalary += amount;
    }

    function addFund() payable public onlyOwer returns (uint)  {
        return address(this).balance;
    }

    function calculateRunway() public onlyOwer view returns (uint) {
        require(totalSalary > 0);
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public onlyOwer view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public onlyEmployee employeeExist(msg.sender) {
        
        address employeeAddress = msg.sender;
        Employee employee = employees[employeeAddress];
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employeeAddress.transfer(employee.salary);
    }
}

