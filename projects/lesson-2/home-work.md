calculateRunway() 执行消耗Gas记录

               account			      execution cost
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	1731
0x14723a09acff6d2a60dcdf7aa4aff308fddc160c	2512
0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db	3293
0x583031d1113ad414f02576bd6afabfb302140225	4074
0xdd870fa1b7c4700f2bd7f44238821c26f7392148	4855

变化
增加一个emploee 会增加781 wei

原因
 for(uint i = 0; i < employees.length; i++){
 	totalSalary += employees[i].salary;
 }
这里添加一个员工，会使for循环多一次

优化方案
添加storge变量，将totalSalary的值存储到里面，避免每次for循环计算