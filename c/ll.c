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

void remove_first(List list, Node node)
{
	if (list.first != NULL)
	{
		list.first = list.first->next;
	}
	else
	{
		list.first = NULL;
	}
}

void insert_after(Node node, Node newNode)
{
	newNode.next = node.next;
	node.next = &newNode;
}

void remove_after(List list, Node node)
{
	Node *toRemove = node.next;
	if (toRemove != NULL)
	{
		Node *nextNode = toRemove->next;
		node.next = nextNode;
		update_last(list, *toRemove, *nextNode);
	}
	else
	{
		node.next = NULL;
	}
}

void update_last(List list, Node prevNode, Node newNode)
{
	// Check to see if the prev node is the last node, and if so update
	// it to be the new node
	if (list.last == &prevNode)
	{
		list.last = &newNode;
	}
	else
	{
		list.last = NULL;
	}
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
