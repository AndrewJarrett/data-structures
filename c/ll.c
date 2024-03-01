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

void insert_after(List list, Node node, Node new_node)
{
	new_node.next = node.next;
	node.next = &new_node;

	update_last(list, node, new_node);
}

void remove_after(List list, Node node)
{
	Node *to_remove = node.next;
	if (to_remove != NULL)
	{
		Node *next_node = to_remove->next;
		node.next = next_node;
		update_last(list, *to_remove, *next_node);
	}
	else
	{
		node.next = NULL;
		update_last(list, *to_remove, *node.next);
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
		Node *prev_node = list.first;
		Node *node = prev_node->next;

		do
		{
			// Is this the last node?
			if (node == NULL)
			{
				// Only happens at the beginning
				prev_node->next = NULL;
				list.last = prev_node;
				break;
			}
			else if (node->next == NULL)
			{
				// Remove this node (i.e. the node after the prev node)
				remove_after(list, *prev_node);
			}

			prev_node = node;
		}
		while (node->next != NULL);
	}
}

Node *get(List *list, int i)
{
	Node *return_node;

	if (i >= list->size || i < 0) 
	{
		// Return null value
		return return_node;
	}
	else
	{
		int j = 0;
		Node *node = list->first;

		while (j <= i)
		{
			node = node->next;
			return_node = node;
		}
	}

	return return_node;
}

Node* remove(List *list, int i)
{
	Node *return_node;
	Node *prev_node;

	if (list != NULL && (i >= list->size || i < 0))
	{
		// Return null value
		return return_node;
	}
	else
	{
		int j = 0;
		Node *prev_node = list->first;

		while (j < i)
		{
			prev_node = prev_node->next;
			return_node = prev_node;
		}
	}

	return_node = prev_node->next;
	remove_after(*list, *prev_node);

	return return_node;
}

void update_last(List list, Node prev_node, Node new_node)
{
	// Check to see if the prev node is the last node, and if so update
	// it to be the new node
	if (list.last == &prev_node)
	{
		list.last = &new_node;
	}
}

void ll_test(int num_nodes)
{
	printf("Creating a linked list with %i number of nodes.\n", num_nodes);

	List list;
	Node prev_node;

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
			insert_after(prev_node, node);
		}

		prev_node = node;
		list.size = i + 1;
	}

	printf("Total linked list size: %i", list.size);
}
