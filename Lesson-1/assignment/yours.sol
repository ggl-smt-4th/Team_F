pragma solidity ^0.4.14;

contract SinglePayroll {
   uint salary;
   address employee;
   uint payDuration = 30 days;
   uint lastPayday;

   function SinglePayroll() {
       lastPayday = now;
   }

   function addFund() payable returns (uint) {
       return this.balance;
   }

   function updateEmployee(address e) {

       if (e == 0x0) {
           revert();
       }

        if (employee ==  e) {
            revert();
        }

        employee = e;
        lastPayday = now;

   }

   function updateSalary(uint s) {
        if (s == salary) {
            revert();
        }

        salary = s;
   }

   function getPaid() {

       if (employee == 0x0) {
           revert();
       }

       if (salary == 0) {
           revert();
       }

       uint nextPayday = lastPayday + payDuration;
       if (nextPayday > now) {
           revert();
       }

       if (this.balance/salary == 0) {
           revert();
       }

       lastPayday = nextPayday;

       employee.transfer(salary);
   }


}