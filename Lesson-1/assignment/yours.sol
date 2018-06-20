/*作业请提交在这个目录下*/
/*第一课作业*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    //更改员工地址以及员工薪水
    function updateEmployee(address e, uint s) {
       //只有雇主可以更改薪水及地址
       if(owner != msg.sender){
           revert();
       }
       //薪水必须大于零，uint是无状态int类型，没有负数情况
       if(s == 0){
           revert();
       }

       salary = s;
       employee = e;
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
    
    //实现课上所教的单员工智能合约系统，
    function getPaid() {
       //只有员工本人可以使用
       if(msg.sender != employee) {
           revert();
       }
       //定义变量存储最新支付工资的日期
       uint nextPayDay = lastPayday + payDuration;
       if(nextPayDay > now) {
           revert();
       }
       lastPayday = nextPayDay;
       employee.transfer(salary);
    }
}
