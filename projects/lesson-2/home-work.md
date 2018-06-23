calculateRunway() 函数每次执行消耗的Gas如下：  

| account        |  execution cost  |
| --------   | :----: |
| 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c        |   1731    |
| 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db        |   2512    |
| 0x583031d1113ad414f02576bd6afabfb302140225        |   3293    |
| 0xdd870fa1b7c4700f2bd7f44238821c26f7392148        |   4074    |
| 0x5dcaa1d8d8132e5bf9cf12deccfc0cecf26a780d        |   4855    |
| 0x96af5cc7dc6d9aa1b2b6c7392a3d06f6301df66a        |   5636    |
| 0x5a9e54056ea941b6a85e44d0c11b5c51028810d7        |   6417    |
| 0x003f673875277fe2b31b9d6cf60902cbc052637f        |   7198    |
| 0x0ffd03b2c11a160c62b7ba1d0f20b42166f27711        |   7979    |
| 0x84784fddf4f83803994bcdfa9aa0de73f14f0158        |   8760    |

**规律**：  
1、每次递增781 wei

**递增原因**：  
1、每增加一个员工，for语句就多循环1次

**改进方案**：  
1、增加一个全部变量（比如totalSalary），每次增加、删除和更新员工薪资时更新改全局变量即可  
2、改进后，每次调用calculateRunway()函数只需要1089 wei
