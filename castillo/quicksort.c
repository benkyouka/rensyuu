#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define SIZE 12

void swap(int * a, int * b )
{
  int tmp = *b;
  *b = *a;
  *a = tmp;
}



void bubble_sort(int sort_me[], int my_size)
{ 
  int ok = 0;
  int i = 0;
  while (ok < (my_size-1)) {
    ok = 0;
    for(i=0;i<(my_size-1);i++) {
      if (sort_me[i] <= sort_me[i+1]) {
	ok++;
      } else {
	swap(&sort_me[i],&sort_me[i+1]);
      }
    }
  }
}

void print_array(int array[], int size)
{
  int i;
  for(i=0;i<size;i++) {
    printf("%d\n",array[i]);
  }
}


//      printf("%d %d %0d %0d\n",i,i+1,sort_me[i],sort_me[i+1]);


int
main()
{
  int sort[] = { 95, 60, 6, 87, 50, 24, 78, 125, 87, 50,234,529 };

  int i,ok,pivot;
  ok = 0;
  i = 0;
  
  // for the pivot use the median of first, middle, last elements. 

  int pivot_candidates[] = { sort[0],sort[SIZE/2],sort[SIZE-1] } ;
  bubble_sort(pivot_candidates,3);
  pivot = pivot_candidates[1]; // the median



  exit(EXIT_SUCCESS);
}

	   


//void print_array(int
