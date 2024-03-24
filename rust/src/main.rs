use crate::ll::LinkedList;

mod ll;

fn main() {
    // Do linked list stuff
    let value: u32 = 0;

    let mut list = LinkedList::<u32>::new(Some(value));

    dbg!(&list);

    for i in 1..100 {
        let _ = list.add_first(i);
    }

    dbg!(&list);

    for _i in 1..101 {
        dbg!(list.remove_first());
    }

    dbg!(list);
}
