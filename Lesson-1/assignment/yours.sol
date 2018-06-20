/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract payRoll {
    uint constant payDuration = 10 seconds;
    address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary = 1 ether;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint lastPayday = now;
    
    function updateEmployee(address e, uint s) {
        if(msg.sender != owner){
            revert();
        }
        if(s == 0){
            revert();
        }
    }employee = e;
    salary = s;
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
      if(msg.sender != employee){
	   revert();
	   }
      uint nextPayday = lastPayday+payDuration;
      if(nextPayday > now ){
          revert();
          
      }
      lastPayday = nextPayday;
      employee.transfer(salary);
    }
}
