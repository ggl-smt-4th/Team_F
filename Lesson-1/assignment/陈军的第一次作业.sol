/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733d;
    uint salary=1 ether;
    address employee=0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint lastPayday = now ;

    
    //根据传入参数动态更改钱包地址和薪水额度
	function updateEmployee(address e, uint s) {
		//如果是只有owner才能调用此函数更改，需要加上以下条件
	   if(msg.sender != owner){
	   revert();
	   }
       employee = e;
       salary = s;
     
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
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

