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

    // 几个getter函数, 方便调试, 上线可删除
    function getOwner() constant returns (address) {
        return owner;
    }

    function getEmployee() constant returns (address) {
        return employee;
    }

    function getSalary() constant returns (uint) {
        return salary;
    }

    function getLastPayDay() constant returns (uint) {
        return lastPayday;
    }

    function calculateRunway() constant returns (uint) {
        // 防止"除数为0的异常"
        if(salary == 0) {
            revert();
        }
        return this.balance / salary;
    }

    function hasEnoughFund() constant returns (bool) {
        return calculateRunway() > 0;
    }

    function updateEmployee(address e, uint s) {
        // 只有owner可以调用
        if(msg.sender != owner) {
            revert();
        }

        // salary不允许为为0: 主要是为0会引起calculateRunway()异常
        if(s == 0) {
            revert();
        }

        // 若employee没有变化，则认为只是salary调整，不更新lastPayday
        if(employee != e) {
            lastPayday = now;  // 将当前时间初始化为: 首次雇佣时间
            employee = e;
        }
        salary = s;
    }

    function addFund() payable returns (uint) {
        // 不限制调用者身份
        return this.balance;
    }

    function getPaid() {
        // 只有employee可以调用
        if(msg.sender != employee) {
            revert();
        }

        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay > now) {
            revert();
        }
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}
