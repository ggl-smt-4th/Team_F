加入十个员工，每个员工的薪水都是 1ETH,每次加入一个员工后调用 `calculateRunway()` 这个函数，消耗的 gas情况如下：
employeeId	                             execution cost 
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	52803
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	53644
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	54485
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	55326
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	56167
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	57008
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	57849
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	58690
0xca35b7d915458ef540ade6068dfe2f44e8fa733c	59531

每次调用addEmployee 这个函数，消耗增加781gas，原因是在调用FOR循环语句时后一次会比前一次多调用循环employees时增加了一次，这样造成多余的gas消耗。
优化思路：设置一个全局变量 totalSalary ，在调用addEmployee()时，变化totalSalary的值，调用removeEmployee()和updateEmployee时也相应变化totalSalary，最后调用calculateRunway()时每次就是固定的gas消耗，测试时，优化后每次消耗
860 gas。
