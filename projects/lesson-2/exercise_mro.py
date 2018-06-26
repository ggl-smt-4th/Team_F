#!/usr/bin/env python
# -*- coding: utf-8 -*-


class Type(type):
    def __repr__(cls):
        return cls.__name__


class O(object, metaclass=Type):
    pass


class A(O):
    pass


class B(O):
    pass


class C(O):
    pass


class K1(A, B):
    pass


class K2(A, C):
    pass


class Z(K1, K2):
    pass


def test_c3_linearization():
    print(Z.mro())

    # Z, K1, K2, A, B, C, O
    pass


if __name__ == '__main__':
    test_c3_linearization()
