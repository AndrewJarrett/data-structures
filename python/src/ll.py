
class LinkedList:
    head = None
    tail = None

    def add_head(self, value):
        new_head = Node(value)

        if not self.head is None:
            old_head = self.head
            new_head.next = old_head

        self.head = new_head

        if self.tail is None:
            self.tail = self.head

    def remove_head(self):
        current_head = self.head
        next_head = current_head.next
        self.head = next_head

        if current_head == self.tail:
            self.tail = None

        return current_head.value

    def add_tail(self, value):
        new_node = Node(value)

        if not self.tail is None:
            node = self.head
            while not node is None:
                if node.next == None:
                    break
                else:
                    node = node.next
            node.next = new_node

        self.tail = new_node


    def remove_tail(self):
        value = self.tail.value

        if not self.tail is None:
            node = self.head
            while not node is None:
                if node.next == self.tail:
                    break
                else:
                    node = node.next
            self.tail = node

        return self.tail.value

    def __str__(self):
        node = self.head
        info = "List: "
        if not self.head is None:
            info += "(head)"
            if not self.head.next is None:
                info += " -> "
                while not node is None:
                    info += str(node)
                    node = node.next
            if not self.tail is None:
                info += " -> (tail)"
        else:
            info += "[]"

        return info


class Node:
    next = None
    value = None

    def __init__(self, value):
        self.value = value

    def __str__(self):
        info = "[" + str(self.value) + "]"
        if not self.next is None: 
            info += " -> "
        return info

if __name__ == "__main__":
    list = LinkedList()
    print(list)
    list.add_head(5)
    print(list)
    list.add_head(3)
    print(list)
    val = list.remove_head()
    print("val: ", val)
    print(list)
    list.add_tail(10)
    list.add_tail(15)
    print(list)
    val2 = list.remove_tail()
    print("val2: ", val2)
    val3 = list.remove_tail()
    print("val3: ", val3)
    print(list)
