#include <stdio.h>

int main(int argc, char *argv[]) 
{
	printf("Welcome to data structures in C! Let's have fun.");

	printf("Here is the linked list implementation");

	static const int NUM_NODES = 100;
	for (int i = 0; i < NUM_NODES; i++)
	{
		printf("Insert node %i", i);
	}
}
