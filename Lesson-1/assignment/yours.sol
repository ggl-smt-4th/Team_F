/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract payRoll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint salary;
    address employee;
    uint lastPayday;
 
    function Payroll(){
          owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s) {
        if(employee != 0x0){
	  unit payment = salary * (now - lastPayday) / payDuration);
	  employee.transfer(payment);
	  }
	
	require(msg.sender == owner);
	require(s != 0);
    
    employee = e;
    salary = s * 1 ether;
    lastPayday = now;
}

function addFund() payable returns (uint) {
    return this.balance;
}
 function calculateRunway() returns (uint) {
     return calculateRunway() > 0;
 }
 
 function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
      require(msg.sender == employee);
     
      uint nextPayday = lastPayday+payDuration;
      assert(nextPayday < now);
      
      lastPayday = nextPayday;
      employee.transfer(salary);
    }
}
