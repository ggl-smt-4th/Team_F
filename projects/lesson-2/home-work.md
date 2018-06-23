
### 10次调用 [addEmployee(), calculateRunway()] 的cost记录


- 0. addFund()

```
 transaction cost 	21921 gas 
 execution cost 	649 gas 
```
 
 
- 1. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C', 1)

```
 transaction cost 	104834 gas 
 execution cost 	81962 gas 
```
 
 
- calculateRunway()

```
 transaction cost 	22966 gas
 execution cost 	1694 gas
```


- 2. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160B', 1)

```
 transaction cost 	90675 gas 
 execution cost 	67803 gas
```


- calculateRunway()

```
 transaction cost 	23747 gas 
 execution cost 	2475 gas
```


- 3. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160A', 1)

```
 transaction cost 	91516 gas 
 execution cost 	68644 gas 
```


- calculateRunway()

```
 transaction cost 	24528 gas 
 execution cost 	3256 gas
```


- 4. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC1609', 1)

```
 transaction cost 	92357 gas 
 execution cost 	69485 gas
```


- calculateRunway()

```
 transaction cost 	25309 gas 
 execution cost 	4037 gas
```


- 5. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC1608', 1)

```
 transaction cost 	93198 gas 
 execution cost 	70326 gas
```


- calculateRunway()

```
 transaction cost 	26090 gas 
 execution cost 	4818 gas 
```


- 6. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC1607', 1)

```
 transaction cost 	94039 gas 
 execution cost 	71167 gas
```


- calculateRunway()

```
 transaction cost 	26871 gas 
 execution cost 	5599 gas
```


- 7. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC1606', 1)

```
 transaction cost 	94880 gas 
 execution cost 	72008 gas
```


- calculateRunway()

```
 transaction cost 	27652 gas 
 execution cost 	6380 gas 
```


- 8. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC1605', 1)

```
 transaction cost 	95721 gas 
 execution cost 	72849 gas
```


- calculateRunway()

```
 transaction cost 	28433 gas 
 execution cost 	7161 gas
```


- 9. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC1604', 1)

```
 transaction cost 	96562 gas 
 execution cost 	73690 gas
```


- calculateRunway()

```
 transaction cost 	29214 gas 
 execution cost 	7942 gas
```


- 10. addEmployee('0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC1603', 1)

```
 transaction cost 	97403 gas 
 execution cost 	74531 gas
```
 
 
- calculateRunway()

```
 transaction cost 	29995 gas
 execution cost 	8723 gas
```
 
 
### 总结


- 10次调用calculateRunway(), cost的变化

```
execution cost: 第i次 - 第i-1次 = 781gas(i>=2)
transaction cost: 第i次 - 第i-1次 = 781gas(i>=2)
```

分析: 
1. 主要原因是由于calculateRunway()函数内的操作是遍历employees数组，而随着employees数组长度+1，导致循环内的操作执行次数+1，而循环内的操作是固定是，故数组长度+1，引起的cost也固定为+781gas


- 10次调用addEmployee, cost的变化

```
execution cost: 第i次 - 第i-1次 = 841gas(i>=3)
transaction cost: 第i次 - 第i-1次 = 841gas(i>=3)
```

分析: 
1. 主要原因addEmployee()函数所调用的_findEmployee()函数其内部会遍历employees数组，而随着employees数组长度+1，导致循环内的操作执行次数+1，而循环内的操作是固定是，故数组长度+1，引起的cost也固定为+841gas
2. 比较特殊的是，第2次的execution cost和transaction cost都比第1次小，原因可能是首次调用addEmployee()函数时，需要对函数代码中的employees数组做初始化导致的


### calculateRunway()函数的优化思路

- 可通过新增"状态变量totalSalary"，并在addEmployee(), removeEmployee(), updateEmployee()函数中维护totalSalary的值变更
- 优化后的代码位于"lesson-2/contracts/PayrollOpt.sol"
- 如此优化后，calculateRunway()函数内无需遍历employees数组，直接使用"状态变量totalSalary"的值，故其调用cost固定为: transaction cost(22132 gas), execution cost(860 gas)
- 不过，addEmployee(), removeEmployee(), updateEmployee()几个函数，由于加入了维护totalSalary的逻辑，其相应的调用cost也会增加某常量值

