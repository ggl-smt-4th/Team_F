
pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        //your code here
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint totalSalary;
    address owner;
    Employee[] employees;
    
    /*构造函数 */
    function Payroll() payable public {
        owner = msg.sender; 
    }

    /*支付工资 */
    function _particlePaid(Employee employee) private{
        uint payment = employee.salary * (now -employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    //查找员工及所在位置
    function _findEmployee(address newAddr) private returns (Employee, uint) {
        for (uint i=0; i<employees.length; i++){
            if (employees[i].id == newAddr){
                return (employees[i], i);
            }
        }
    }
    
    /*添加员工*/
    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee,index) = _findEmployee(employeeAddress);
        assert(employee.id == 0x0);
        
        totalSalary += salary * 1 ether;
        employees.push(Employee(employeeAddress,salary * 1 ether,now));
    }

     /*删除员工*/
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
        totalSalary -= employee.salary;
    }

    /*更新员工信息*/
    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee,index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x0);
        
        _particlePaid(employee);
        
        totalSalary -= employee.salary * 1 ether;
        totalSalary += salary * 1 ether;
        
        employee.id = employeeAddress;
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        assert (totalSalary > 0);

        return address(this).balance / totalSalary;
        
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var (employee, index) = _findEmployee(msg.sender);

        assert (employee.id != 0x0);

        uint nextPayDay = employee.lastPayday + payDuration;

        assert (nextPayDay <= now);
        
        employees[index].lastPayday = nextPayDay;

        employee.id.transfer(employee.salary);
    }
}
