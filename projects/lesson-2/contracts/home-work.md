在verision-1的版本中，每加入一个员工之后，然后call calculateRunaway() funciton 记录下来的gas execution fee 如下
number of employees  |  gas fee
1                       1710 
2                       2499
3                       3288
4                       4077
5                       4866
6                       5655
7                       6444
8                       7233
9                       8022
10                      8811
可以明显发现，消耗的gas费用是线性增长的，也即是说明增长的部分是iterate through for loop 每一个元素造成的结果。

因此，我想到的初步解决办法是，可以把for loop计算总共需要支付的工资，移除，单独创建一个addSalary()的函数来解决这个问题，最终得到的结果
就是提交的版本里面的结果。
但是，这个方法应该是只能治标而不能治本的，因为并没有减少总体消耗gas的量，想来肯定有更好的算法或函数方法能够解决，暂时由于知识有限，还不能
解决，但会继续思考。
