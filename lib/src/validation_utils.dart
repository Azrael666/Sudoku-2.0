part of sudokulib;


bool validateRow(List<List<int>> field,int row){
  if(!testField(field))
    return false;

  if(row<0 || row>8)
    return false;

  List<int> numbers = [1,2,3,4,5,6,7,8,9];

  for(int i=0;i<9;i++){
    numbers.remove(field[row][i]);
  }

  if(numbers.length==0)
    return true;

  return false;

}

bool validateColumn(List<List<int>> field,int col){
  if(!testField(field))
    return false;

  if(col<0 || col>8)
    return false;

  List<int> numbers = [1,2,3,4,5,6,7,8,9];

  for(int i=0;i<9;i++){
    numbers.remove(field[i][col]);
  }

  if(numbers.length==0)
    return true;

  return false;
}


bool validateCube(List<List<int>> field,int row,int col){
  if(!testField(field))
    return false;

  if(row<0 || row>2 || col<0 || col>2)
    return false;

  List<int> numbers = [1,2,3,4,5,6,7,8,9];

  for(int i=0;i<3;i++){
    for(int i1=0;i1<3;i1++){
      numbers.remove(field[row*3+i][col*3+i1]);
    }
  }

  if(numbers.length==0)
    return true;

  return false;

}

bool validateDiagonal(List<List<int>> field){
  if(!testField(field))
    return false;

  List<int> numbers = [1,2,3,4,5,6,7,8,9];
  for(int i=0;i<9;i++){
    numbers.remove(field[i][i]);
  }
  if(numbers.length!=0)
    return false;

  numbers = [1,2,3,4,5,6,7,8,9];
  for(int i=0;i<9;i++){
    numbers.remove(field[8-i][i]);
  }
  if(numbers.length!=0)
    return false;

  return true;


}

bool validateStandardSudoku(List<List<int>> field){
  for(int i=0;i<9;i++){
    if(!validateRow(field, i))
      return false;
    if(!validateColumn(field, i))
      return false;
  }

  for(int i=0;i<3;i++){
    for(int i1=0;i1<3;i1++){
      if(!validateCube(field, i, i1))
        return false;
    }
  }
  return true;
}

bool validateXSudoku(List<List<int>> field){
  if(!validateStandardSudoku(field))
    return false;

  if(!validateDiagonal(field))
    return false;

  return true;
}

