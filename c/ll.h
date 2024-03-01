#include <stdio.h>
#include <stdbool.h>

typedef struct Node {
	int value;
	struct Node *next;
} Node;

typedef struct List {
	struct Node *first;
	struct Node *last;
	int size;
} List;

void insert_first(List *p_list, Node node);
void remove_first(List *p_list);
void insert_after(List *p_list, Node node, Node newNode);
void remove_after(List *p_list, Node node);
void insert_last(List *p_list, Node node);
void remove_last(List *p_list);

Node* get_node(List *p_list, int i);
Node* remove_node(List *p_list, int i);

void update_last(List *p_list, Node prevNode, Node newNode);

// Test methods
void ll_test_main(int num_nodes);
List* ll_test_insert(int num_nodes);
void ll_test_remove(List *list);

