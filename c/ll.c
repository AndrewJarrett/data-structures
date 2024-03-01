#include <stdio.h>

#include "ll.h"

void insert_first(List list, Node node)
{
	list.first = &node;

	if (list.last == NULL)
	{
		list.last = &node;
	}
}

void insert_after(Node node, Node newNode)
{
	newNode.next = node.next;
	node.next = &newNode;
}

void ll_test(int num_nodes)
{
	printf("Creating a linked list with %i number of nodes.\n", num_nodes);

	List list;
	Node priorNode;

	for (int i = 0; i < num_nodes; i++)
	{
		Node node;
		node.value = i;
		
		if (list.first == NULL) 
		{
			insert_first(list, node);
		}
		else
		{
			insert_after(priorNode, node);
		}

		priorNode = node;
		list.size = i + 1;
	}

	printf("Total linked list size: %i", list.size);
}
