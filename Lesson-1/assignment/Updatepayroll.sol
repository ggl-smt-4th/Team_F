/*作业请提交在这个目录下*/
contract Updatepayroll {
    uint constant payDuration = 10 seconds;

    address addrofBoss = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    address addrofEmployee;
    uint salary;
    uint lastPayDay = now;

    function setPaymentInfo(address e, uint s) {
        require(msg.sender == addrofBoss);

        addrofEmployee = e;
        salary = s * 1 ether;
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
        require(msg.sender == addrofEmployee);

        uint nextPayDay = lastPayDay + payDuration;
        if (nextPayDay < now) {
           lastPayDay = nextPayDay;
           addrofEmployee.transfer(salary);
        }
    }
}
