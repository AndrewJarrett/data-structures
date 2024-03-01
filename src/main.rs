use crate::ll::{Node, LinkedList};

mod ll;

fn main() {
    // Do linked list stuff
    let node: Node<u32> = Node::<u32>::new(0, None);

    let mut list = LinkedList::<u32>::new(&node);

    dbg!(list);

    for i in 1..100 {
        let new_node: Node<u32> = Node::<u32>::new(i, None);
        list.add(i.into(), &new_node);
        dbg!(list);
    }
}
