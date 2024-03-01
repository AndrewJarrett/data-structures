#include <stddef.h>

#include "ll.h"

void insert_first(List *p_list, Node *p_node)
{
	p_list->first = p_node;

	if (p_list->last == NULL)
	{
		p_list->last = p_node;
	}
}

void remove_first(List *p_list)
{
	if (p_list->first != NULL)
	{
		p_list->first = p_list->first->next;
	}
	else
	{
		p_list->first = NULL;
	}
}

void insert_after(List *p_list, Node *p_node, Node *p_new_node)
{
	p_new_node->next = p_node->next;
	p_node->next = p_new_node;

	update_last(p_list, p_node, p_new_node);
}

void remove_after(List *p_list, Node *p_node)
{
	Node *to_remove = p_node->next;
	if (to_remove != NULL)
	{
		Node *next_node = to_remove->next;
		p_node->next = next_node;
		update_last(p_list, to_remove, next_node);
	}
	else
	{
		p_node->next = NULL;
		update_last(p_list, to_remove, p_node->next);
	}
}

void insert_last(List *p_list, Node *p_node)
{
	if (p_list->last != NULL)
	{
		p_list->last->next = p_node;
		p_list->last = p_node;
	}
}

void remove_last(List *p_list)
{
	if (p_list->last != NULL && p_list->first != NULL)
	{
		Node *prev_node = p_list->first;
		Node *node = prev_node->next;

		do
		{
			// Is this the last node?
			if (node == NULL)
			{
				// Only happens at the beginning
				prev_node->next = NULL;
				p_list->last = prev_node;
				break;
			}
			else if (node->next == NULL)
			{
				// Remove this node (i.e. the node after the prev node)
				remove_after(p_list, prev_node);
			}

			prev_node = node;
		}
		while (node->next != NULL);
	}
}

Node *get_node(List *p_list, int i)
{
	Node *return_node;

	if (i >= p_list->size || i < 0) 
	{
		// Return null value
		return return_node;
	}
	else
	{
		int j = 0;
		Node *node = p_list->first;

		while (j <= i)
		{
			node = node->next;
			return_node = node;
		}
	}

	return return_node;
}

Node* remove_node(List *p_list, int i)
{
	Node *return_node;
	Node *prev_node;

	if (p_list != NULL && (i >= p_list->size || i < 0))
	{
		// Return null value
		return return_node;
	}
	else
	{
		int j = 0;
		Node *prev_node = p_list->first;

		while (j < i)
		{
			prev_node = prev_node->next;
			return_node = prev_node;
		}
	}

	return_node = prev_node->next;
	remove_after(p_list, prev_node);

	return return_node;
}

void update_last(List *p_list, Node *p_prev_node, Node *p_new_node)
{
	// Check to see if the prev node is the last node, and if so update
	// it to be the new node
	if (p_list->last == p_prev_node)
	{
		p_list->last = p_new_node;
	}
}
