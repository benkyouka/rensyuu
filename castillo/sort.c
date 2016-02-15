#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define SIZE 10


int
main()
{
  int sort[] = { 95, 60, 6, 87, 50, 24, 78, 125, 87, 50 };
  int i,ok,tmp;
  ok = 0;

  while (ok < (SIZE-1))
    {
      ok = 0;
      for(i=0;i<(SIZE-1);i++)
	{
	  printf("%d %d %0d %0d\n",i,i+1,sort[i],sort[i+1]);
	  if (sort[i] <= sort[i+1])
	    {
	      ok++;
	    }
	  else
	    {
	      tmp = sort[i];
	      sort[i] = sort[i+1];
	      sort[i+1] = tmp;
	    }
	}
    }
  for(i=0;i<SIZE;i++)
    {
      printf("%d\n",sort[i]);
    }
  exit(EXIT_SUCCESS);
}

//void print_array(int
