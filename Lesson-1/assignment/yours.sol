pragma solidity ^0.4.14;

contract SinglePayroll {
	// the current employee's salary
   uint salary;
   // the current employee
   address employee;
   // the current employee's pay duration
   uint payDuration = 30 days;
   // the current employee's last pay day
   uint lastPayday;

   // constructor: initialize last pay day (actually this is not necessary)
   function SinglePayroll() {
       lastPayday = now;
   }

   function addFund() payable returns (uint) {
       return this.balance;
   }


   //update employee: 
   //  do it only when the input address exists and differs from the existing one
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

   //update salary
   // do it when the input salary is different from the current value
   function updateSalary(uint s) {
        if (s == salary) {
            revert();
        }

        salary = s;
   }

   // the employee get paid only when: 
   //   1) the next pay day is not beyond now 
   //   2) there is enough balance in the contract address
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