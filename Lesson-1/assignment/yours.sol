pragma solidity ^0.4.14;

contract SinglePayroll {
   uint salary = 10 wei;
   address frank = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
   uint payDuration = 5 seconds;
   uint lastPayday;

   function SinglePayroll() {
       lastPayday = now;
   }

   function addFund() payable returns (uint) {
       return this.balance;
   }

   function getPaid() {
       uint nextPayday = lastPayday + payDuration;
       if (nextPayday > now) {
           revert();
       }

       if (this.balance/salary == 0) {
           revert();
       }

       lastPayday = nextPayday;

       frank.transfer(salary);
   }


}