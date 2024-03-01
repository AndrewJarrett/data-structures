#include <stdio.h>

#include "ll.c"

void ll_test_main(int num_nodes)
{
	List *p_list;
	p_list = ll_test_insert(num_nodes);
	ll_test_remove(p_list);
}

List* ll_test_insert(int num_nodes)
{
	printf("Creating a linked list with %i number of nodes.\n", num_nodes);

	List list;
	List *p_list = &list;
	Node *p_prev_node;

	for (int i = 0; i < num_nodes; i++)
	{
		//printf("Inserting node %i\n", i);
		Node node;
		node.value = i;
		Node *p_node = &node;
		
		if (p_list != NULL && p_list->first == NULL) 
		{
			insert_first(p_list, p_node);
		}
		else
		{
			insert_after(p_list, p_prev_node, p_node);
		}

		p_prev_node = p_node;
		p_list->size = i + 1;
	}

	printf("Total linked p_list size: %i\n\n", p_list->size);

	return p_list;
}

void ll_test_remove(List *p_list)
{
	printf("Removing %i nodes from the linked list.\n", list->size);

	if (p_list != NULL && p_list->first != NULL)
	{
		Node *p_node = p_list->first;

		while (p_node->next != NULL)
		{
			remove_after(p_list, p_node);
			p_node = p_node->next;
		}
	}
}
