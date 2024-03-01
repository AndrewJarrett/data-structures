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

void insert_first(List list, Node node);
void remove_first(List list);
void insert_after(List list, Node node, Node newNode);
void remove_after(List list, Node node);
void insert_last(List list, Node node);
void remove_last(List list);

void update_last(List list, Node prevNode, Node newNode);

void ll_test(int num_nodes);
