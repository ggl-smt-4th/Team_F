/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    
    uint constant payDuration = 1 seconds;

    address owner;
    address employee;
    uint salary;
    uint lastPayday;

    constructor () public {
        owner = msg.sender;
        lastPayday = now;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyEmployee() {
        require(msg.sender == employee);
        _;
    }

    function updateEmployee(address _employee, uint _salary) public onlyOwner {
        if(employee == 0x0 || owner == _employee){
            revert();
        }

        employee = _employee;
        salary = _salary * 1 ether;
    }

    function addFund() payable public onlyOwner returns (uint){
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance / salary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public payable onlyEmployee {
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday < now || address(this).balance < salary) {
            revert();
        }

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}