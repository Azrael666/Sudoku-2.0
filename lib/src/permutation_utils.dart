part of sudokulib;



bool testField(List<List<int>> field){
  if(field == null)
    return false;

  if(field.length != 9)
    return false;

  for(List<int> list in field)
    if(list.length != 9)
      return false;

  return true;


}


void swapRows(List<List<int>> field, int row1,int row2){
  if(!testField(field))
    return;

  if(row1>8 || row1<0 || row2>8 || row2<0 || row1==row2)
    return;

  for(int i=0;i<9;i++){
    int tmp = field[row1][i];
    field[row1][i]= field[row2][i];
    field[row2][i] = tmp;
  }
}


void swapColumns(List<List<int>> field, int col1,int col2){
  if(!testField(field))
    return;

  if(col1>8 || col1<0 || col2>8 || col2<0 || col1==col2)
    return;

  for(int i=0;i<9;i++){
    int tmp = field[i][col1];
    field[i][col1]= field[i][col2];
    field[i][col2] = tmp;
  }
}

swapWideRows(List<List<int>> field, int row1,int row2){
  if(!testField(field))
    return;
  if(row1>2 || row1<0 || row2>2 || row2<0)
    return;

  swapRows(field, row1*3+0, row2*3+0);
  swapRows(field, row1*3+1, row2*3+1);
  swapRows(field, row1*3+2, row2*3+2);


}

void swapWideColumns(List<List<int>> field, int col1,int col2){
  if(!testField(field))
    return;

  if(col1>2 || col1<0 || col2>2 || col2<0)
    return;

  swapColumns(field, col1*3+0, col2*3+0);
  swapColumns(field, col1*3+1, col2*3+1);
  swapColumns(field, col1*3+2, col2*3+2);

}

void flipHorizontal(List<List<int>> field){
  if(!testField(field))
    return;

  swapRows(field, 0, 8);
  swapRows(field, 1, 7);
  swapRows(field, 2, 6);
  swapRows(field, 3, 5);

}

void flipVertical(List<List<int>> field) {
  if (!testField(field))
    return;


  swapColumns(field, 0, 8);
  swapColumns(field, 1, 7);
  swapColumns(field, 2, 6);
  swapColumns(field, 4, 5);
}


void flipDiagonal(List<List<int>> field){
  if (!testField(field))
    return;

  for(int i=0;i<9;i++){
    for(int i1=0;i1<9;i1++){
      if(i!=i1){
        int tmp = field[i][i1];
        field[i][i1] = field[i1][i];
        field[i1][i1] = tmp;
      }
    }
  }
}

void SwitchValues(List<List<int>> field, int value1,int value2){
  if (!testField(field))
    return;

  if(value1>8 || value1<0 || value2>8 || value2<0 || value1==value2)
    return;

  for(int i=0;i<9;i++) {
    for (int i1 = 0; i1 < 9; i1++) {
      if (field[i][i1] == value1)
        field[i][i1] = -1;
      if(field[i1][i1]==value2)
        field[i][i1]= -2;
    }
  }

  for(int i=0;i<9;i++) {
    for (int i1 = 0; i1 < 9; i1++) {
      if (field[i][i1] == -1)
        field[i][i1] = value2;
      if(field[i1][i1]== -2)
        field[i][i1]= value1;
    }
  }


}