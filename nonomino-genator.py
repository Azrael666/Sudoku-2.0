#!/usr/bin/python3.5

import random
def print_lis(lis):
	for i in range(0,9):
		for i1 in range(0,9):
			print(str(lis[i*9+i1]), end ="")
		print("")
	
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
	def swap_rows():
		row1 = random.randint(0,8)
		row2 = row1
		while row2==row1:
			row2 = random.randint(0,8)
		
		try:
			for i in range(0,9):
				tmp = lis[row1*9+i]
				lis[row1*9+i] = lis[row2*9+i]
				lis[row2*9+i] = tmp
		except IndexError:
			print ("row1,row2:"+str(row1),str(row))
		
	def swap_cols():
		col1 = random.randint(0,8)
		col2 = col1
		
		while col2==col1:
			col2 = random.randint(0,8)
		try:
			for i in range(0,9):
				tmp = lis[col1+9*i]
				lis[col1+9*i] = lis[col2+9*i]
				lis[col2+9*i] = tmp
		except IndexError:
			print("col1,col2:",str(col1),str(col2))


	for i in range(10,10+random.randint(0,20)):
		swap_cols()
		swap_rows()

	return lis
	

def main():

	nono = get_list()
	print_lis(nono)
	
main()
