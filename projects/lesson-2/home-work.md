## 每次加入一个员工后调用calculateRunway消耗的gas（共十次）: 
	> 1731, 2512, 3293, 4074, 4855, 5636, 6417, 7198, 7979, 8760
## 结果: 每新增一名员工，执行的cost都会增加
## 原因分析: 
- 目前实现的calculateRunway中，for循环的执行次数和employee的数量相同，因此每增加一名新员工，会多执行一次加法运算，导致cost增加。
## 优化calculateRunway
### 思路: 
		- 在合约中新增totalSalary状态来保存当前所有员工的月工资总额，避免每次执行calcualteRunway时都重新进行计算。
### 过程: 
	  	- 在对employees进行增加(addEmployee)、删除(removeEmployee)和更新(updateEmployee)时，更新totalSalary的值，
	  	- 移除calulateRunway中的for循环。