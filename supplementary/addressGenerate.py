#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 24 16:27:30 2022

@author: useralpha
"""

numberList = []
addressList = []

for i in range(1100,1440):
    numberList.append(i+1)

for i in numberList:
    addressList.append("0x000000000000000000000000000000000000"+str(i))

addressList = str(addressList)
addressList = addressList.replace("'", '"')