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
def swap_rows(lis,row1,row2):

	try:
		for i in range(0,9):
			tmp = lis[row1*9+i]
			lis[row1*9+i] = lis[row2*9+i]
			lis[row2*9+i] = tmp
	except IndexError:
		print ("row1,row2:"+str(row1),str(row))
		
def swap_cols(lis,col1,col2):

	try:
		for i in range(0,9):
			tmp = lis[col1+9*i]
			lis[col1+9*i] = lis[col2+9*i]
			lis[col2+9*i] = tmp
	except IndexError:
		print("col1,col2:",str(col1),str(col2))	
def get_list():	
	lis = [	1,2,3,4,5,6,7,8,9,
		2,3,4,5,6,7,8,9,1,
		3,4,5,6,7,8,9,1,2,
		4,5,6,7,8,9,1,2,3,
		5,6,7,8,9,1,2,3,4,
		6,7,8,9,1,2,3,4,5,
		7,8,9,1,2,3,4,5,6,
		8,9,1,2,3,4,5,6,7,
		9,1,2,3,4,5,6,7,8,
	]



	for i in range(10,10+random.randint(0,20)):
		row1 = random.randint(0,8)
		row2 = row1
		while row2==row1:
			row2 = random.randint(0,8)
		col1 = random.randint(0,8)
		col2 = col1
	
		while col2==col1:
			col2 = random.randint(0,8)
		swap_cols(lis,col1,col2)
		swap_rows(lis,row1,row2)

	return lis

def fix(nono):
	for line in sys.stdin:
		try:
			if "end" in line:
				return
			elif "set" in line:
				high.append(int(str(line).split()[1]))
			elif "unset" in line:
				high.remove(int(str(line).split()[1]))
			elif "col" in line:
				col1 = int(str(line).split()[1])
				col2 = int(str(line).split()[2])
				swap_cols(nono,col1,col2)
				print("col1,col2:",col1,col2)
			elif "row" in line:
				row1 = int(str(line).split()[1])
				row2 = int(str(line).split()[2])
				swap_rows(nono,row1,row2)
			print_lis(nono)
			print ()
		except ValueError:
			pass
			#ignore
	


def main():

	nono = get_list()
	print_lis(nono)
	fix(nono)


	
main()
