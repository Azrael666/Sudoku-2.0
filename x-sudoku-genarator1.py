#!/usr/bin/python3.5

import random
from termcolor import colored
import sys

high = []
def print_lis(lis):
	for i in range(0,9):
		print ("row"+str(i)+": ", end ="")
		for i1 in range(0,9):
			if lis[i*9+i1] in high:
				print(colored(str(lis[i*9+i1]),'blue')+" ", end ="")
			elif i ==i1 or (8-i)==i1:
				print(colored(str(lis[i*9+i1]),'red')+" ", end ="")
			else:
				print(str(lis[i*9+i1])+" ", end ="")
		print("")

def print_lis2(lis):
	print("[")
	for i in range(0,9):
		print ("\t[", end ="")
		for i1 in range(0,9):
			print(str(lis[i*9+i1])+",", end ="")
		print("],")
	print("]")


def swap_values(lis):
	a = random.randint(1,9)
	b = a
	while b==a:
		b = random.randint(1,9)
	for i in range(0,81):
		if lis[i]==a:
			lis[i]= -1
	for i in range(0,81):
		if lis[i]== b:
			lis[i] = a

	for i in range(0,81):
		if lis[i]== -1:
			lis[i] = b

def mirror_vert(lis):
	for i1 in range(0,4):
		a = i1
		b = 8-a
		for i in range(0,9):
			tmp = lis[a+9*i]
			lis[a+9*i] = lis[b+9*i]
			lis[b+9*i] = tmp 
def mirror_hori(lis):
	for i1 in range(0,4):
		a = i1
		b = 8-a
		for i in range(0,9):
			tmp = lis[a*9+i]
			lis[a*9+i] = lis[b*9+i]
			lis[b*9+i] = tmp 


def get_list():	
	lis = [
		1,2,3,4,7,6,4,8,9,
		7,6,9,1,4,8,5,2,3,
		4,8,5,3,9,2,6,7,1,
		6,7,1,2,5,3,8,9,4,
		2,9,4,6,8,7,1,3,5,
		3,5,8,4,1,9,7,6,2,
		8,4,7,9,2,1,3,5,6,
		9,1,6,7,3,5,2,4,8,
		5,3,2,8,6,4,9,1,7,
	]



	for i in range(10,10+random.randint(0,20)):
		mirror_hori(lis)
		mirror_vert(lis)
		swap_values(lis)

	return lis




def main():

	x = get_list()
	print_lis(x)
	print_lis2(x)



	
main()
