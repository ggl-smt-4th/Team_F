加入十个员工，每个员工的薪水都是 1ETH,每次加入一个员工后调用 `calculateRunway()` 这个函数，消耗的 gas情况如下：
addfund：
gas ：3000000
transaction cost ：	21921
execution cost：649

1、
addEmployee("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",1):
gas ：3000000
transaction cost ：	104834
execution cost：81962 

calculateRunway()   
gas ：3000000
transaction cost ：	22974
execution cost：1702
decoded output:"0","uint 256","100"

2、
addEmployee("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db",1):
gas ：3000000
transaction cost ：	90675
execution cost：	67803 

calculateRunway()   
gas ：3000000
transaction cost ：	23755
execution cost：2483
decoded output:"0","uint 256","50"

3、
addEmployee("0x583031d1113ad414f02576bd6afabfb302140225",1):
gas ：3000000
transaction cost ：	91516
execution cost：68644 

calculateRunway()   
gas ：3000000
transaction cost ：	24536
execution cost：3264
decoded output:"0","uint 256","33"

4、
addEmployee("0xdd870fa1b7c4700f2bd7f44238821c26f7392148",1):
gas ：3000000
transaction cost ：		92357
execution cost：69485 

calculateRunway()   
gas ：3000000
transaction cost ：25317
execution cost：4045
decoded output:"0","uint 256","25"

5、
addEmployee("0xdd870fa1b7c4700f2bd7f44238821c26f7392149",1):
gas ：3000000
transaction cost ：		93198
execution cost：70326 

calculateRunway()   
gas ：3000000
transaction cost ：	26098
execution cost：4826
decoded output:"0","uint 256","20"

6、
addEmployee("0xdd870fa1b7c4700f2bd7f44238821c26f7392150",1):
gas ：3000000
transaction cost ：		94039
execution cost：71167 

calculateRunway()   
gas ：3000000
transaction cost ：	26879
execution cost：5607
decoded output:"0","uint 256","16"

7、
addEmployee("0xdd870fa1b7c4700f2bd7f44238821c26f7392151",1):
gas ：3000000
transaction cost ：		94880
execution cost：72008 

calculateRunway()   
gas ：3000000
transaction cost ：	27660
execution cost：6388
decoded output:"0","uint 256","14"

8、
addEmployee("0xdd870fa1b7c4700f2bd7f44238821c26f7392152",1):
gas ：3000000
transaction cost ：	95721
execution cost：	72849 

calculateRunway()   
gas ：3000000
transaction cost ：	28441
execution cost：7169
decoded output:"0","uint 256","12"

9、
addEmployee("0xdd870fa1b7c4700f2bd7f44238821c26f7392153",1):
gas ：3000000
transaction cost ：		96562
execution cost：	73690 

calculateRunway()   
gas ：3000000
transaction cost ：	29222
execution cost：	7950
decoded output:"0","uint 256","11"

10、
addEmployee("0xdd870fa1b7c4700f2bd7f44238821c26f7392154",1):
gas ：3000000
transaction cost ：		97403 
execution cost：	74531 

calculateRunway()   
gas ：3000000
transaction cost ：	30003
execution cost：	8731
decoded output:"0","uint 256","10"
每次调用`calculateRunway()` 这个函数，消耗增加781gas，原因是后一次比较前一次调用循环employees时增加了一次，这样造成多余的gas消耗。
优化思路：设置一个全局变量 totalSalary ，在调用addEmployee()时，变化totalSalary的值，调用removeEmployee()和updateEmployee时也相应变化totalSalary，最后调用calculateRunway()时每次就是固定的gas消耗，测试时，优化后每次消耗
860 gas。