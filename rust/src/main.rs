use crate::ll::{Node, LinkedList};

use std::convert::TryFrom;

mod ll;

fn main() {
    // Do linked list stuff
    let value: u32 = 0;

    let mut list = LinkedList::<u32>::new(Some(value));

    dbg!(&list);

    for i in 1..100 {
        list.add(usize::try_from(i).unwrap(), i);
        dbg!(&list);
    }

    dbg!(list);
}
