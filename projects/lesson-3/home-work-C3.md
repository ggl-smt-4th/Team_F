
- 题目: 自学 C3 Linearization, 求以下 contract Z 的继承线

```
    contract O
    contract A is O
    contract B is O
    contract C is O
    contract K1 is A, B
    contract K2 is A, C
    contract Z is K1, K2
```


- 参考资料: [https://zh.wikipedia.org/wiki/C3%E7%BA%BF%E6%80%A7%E5%8C%96](https://zh.wikipedia.org/wiki/C3%E7%BA%BF%E6%80%A7%E5%8C%96)

- 算法描述

```
一个类的C3超类线性化是这个类，再加上它的各个父类的线性化与各个父类形成列表的唯一合并的结果。父类列表作为合并过程的最后实参，保持了直接父类的本地前趋序。

各个父类的线性化与各个父类形成列表的合并算法，首先选择不出现在各个列表的尾部（指除了第一个元素外的其他元素）的第一个元素，该元素可能同时出现在多个列表的头部。被选中元素从各个列表中删除并追加到输出列表中。这个选择再删除、追加元素的过程迭代下去直到各个列表被耗尽。如果在某个时候无法选出元素，说明这个类继承体系的依赖序是不一致的，因而无法线性化。
```

- 解答:

```
L(0) := [O]

L(A)  := [A] + merge(L(O), [O])
       = [A] + merge([O], [O])
       = [A, O]

L(B)  := [B, O]                  // similar to that of A
L(C)  := [C, O]

L(K1) := [K1] + merge(L(A), L(B), [A, B])
       = [K1] + merge([A, O], [B, O], [A, B])
       = [K1, A] + merge([O], [B, O], [B])
       = [K1, A, B] + merge([O], [O])
       = [K1, A, B, O]

L(K2) := [K2, A, C, O]          // similar to that of K1

L(Z)  := [Z] + merge(L(K1), L(K2), [K1, K2])
       = [Z] + merge([K1, A, B, O], [K2, A, C, O], [K1, K2])
       = [Z, K1] + merge([A, B, O], [K2, A, C, O], [K2])
       = [Z, K1, K2] + merge([A, B, O], [A, C, O])
       = [Z, K1, K2, A] + merge([B, O], [C, O])
       = [Z, K1, K2, A, B] + merge([O], [C, O])
       = [Z, K1, K2, A, B, C] + merge([O], [O])
       = [Z, K1, K2, A, B, C, O]
```

- python代码验证

```python
class A(object):
    pass


class B(object):
    pass


class C(object):
    pass


class K1(A, B):
    pass


class K2(A, C):
    pass


class Z(K1, K2):
    pass


print Z.mro()
```