
pragma solidity ^0.4.14;
import './Ownable.sol';
contract Payroll is Ownable { 
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 30 days;

    address owner;
    mapping(address => Employee) public employees;
    uint totalSalary = 0;
	
	function Payroll() payable public {
        owner = msg.sender;
    }
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    modifier newEmployeeIdExist(address newEmployeeId){
        assert(newEmployeeId != 0x0);
        _;
    }
    function _partialPaid(Employee employee)private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
	    employee.id.transfer(payment);
    }

    
    function addEmployee(address employeeId, uint salary)public onlyOwner{
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId,salary * 1 ether,now);
    }
    function removeEmployee(address employeeId)public onlyOwner employeeExist(employeeId){
         var employee = employees[employeeId];
         _partialPaid(employee);
         //删除员工时减去他的薪水
          totalSalary -=employees[employeeId].salary;
         delete employees[employeeId]; 
        
    }
    //改变员工薪水地址，需要传入原地址和改变后的地址
    function changePaymentAddress(address employeeId, address newEmployeeId)public onlyOwner employeeExist(employeeId) newEmployeeIdExist(newEmployeeId){
         var employee = employees[employeeId];
         employees[newEmployeeId] = Employee(newEmployeeId,employee.salary ,employee.lastPayday);
         delete employees[employeeId];
    
    }
    

	function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId){
	     var employee = employees[employeeId];
	      _partialPaid(employee);
	      //先减去变更的薪水
	      totalSalary -=employees[employeeId].salary;
          employees[employeeId].salary = salary * 1 ether;
          //加上变更后的薪水
           totalSalary +=employees[employeeId].salary;
          employees[employeeId].lastPayday = now;
	    
     
    }
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway()public view returns (uint) {
        
        return this.balance / totalSalary ;
    }
    
    function hasEnoughFund()public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public employeeExist(msg.sender){
      var employee = employees[msg.sender];
      uint nextPayday = employee.lastPayday+payDuration;
      assert(nextPayday < now); 
      employees[msg.sender].lastPayday = nextPayday;
      employee.id.transfer(employee.salary);
    }
}
