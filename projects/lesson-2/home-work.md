# Gas变化记录
优化前的calculateRunway会遍历每一个employee，所以gas随着employee数量的增多会越来越大。

# calculateRunway() 优化思路
优化思路是通过一个totalSalary的状态变量来记载所有employee的工资之和。每次加入employee、
remove employee、update employee salary的时候，都会调整totalSalary.
优化后：
transaction cost: 22132
execution cost: 860
