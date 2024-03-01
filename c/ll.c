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

void remove_first(List list)
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

void insert_after(List list, Node node, Node newNode)
{
	newNode.next = node.next;
	node.next = &newNode;

	update_last(list, node, newNode);
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
		update_last(list, *toRemove, *node.next);
	}
}

void insert_last(List list, Node node)
{
	if (list.last != NULL)
	{
		list.last->next = &node;
		list.last = &node;
	}
}

void remove_last(List list)
{
	if (list.last != NULL && list.first != NULL)
	{
		Node *prevNode = list.first;
		Node *node = prevNode->next;

		do
		{
			// Is this the last node?
			if (node == NULL)
			{
				// Only happens at the beginning
				prevNode->next = NULL;
				list.last = prevNode;
				break;
			}
			else if (node->next == NULL)
			{
				// Remove this node (i.e. the node after the prev node)
				remove_after(list, *prevNode);
			}

			prevNode = node;
		}
		while (node->next != NULL);
	}
}

Node get(List list, int i)
{
	Node returnNode;

	if (i >= list.size || i < 0) 
	{
		// Return null value
		return returnNode;
	}
	else
	{
		int j = 0;
		Node *node = list.first;

		while(j <= i)
		{
			returnNode = *node->next;
		}
	}

	return returnNode;
}

void update_last(List list, Node prevNode, Node newNode)
{
	// Check to see if the prev node is the last node, and if so update
	// it to be the new node
	if (list.last == &prevNode)
	{
		list.last = &newNode;
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
