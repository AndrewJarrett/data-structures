use anyhow::Result;
use std::mem;

#[derive(Debug)]
struct Node<T> {
    next: Option<Box<Node<T>>>,
    value: T,
}

impl<T> Node<T> {
    fn new(value: T, next: Option<Box<Node<T>>>) -> Self {
        Self {
            next,
            value,
        }
    }
}

#[derive(Debug)]
pub struct LinkedList<T> {
    first: Option<Box<Node<T>>>,
    //last: Option<Box<Node<T>>>,
    size: usize,
}

impl<T> LinkedList<T> {
    pub fn new(value: Option<T>) -> Self {
        let mut node: Option<Box<Node<T>>> = None;
        let mut size = 0;

        match value {
            Some(value) => {
                node = Some(Box::new(Node::<T>::new(value, None)));
                size = 1;
            },
            None => {}
        }

        Self {
            first: node,
            //last: node,
            size,
        }
    }

    pub fn add_first(&mut self, value: T) -> Result<()> {
        let node = Some(Box::new(
            Node::<T>::new(value, mem::replace(&mut self.first, None))
        ));

        self.first = node;
        self.size += 1;

        Ok(())
    }

    pub fn remove_first(&mut self) -> Option<T> {
        let old_first: Option<Box<Node<T>>> = mem::replace(&mut self.first, None);

        match old_first {
            Some(old_first) => {
                self.first = old_first.next;
                self.size -= 1;

                Some(old_first.value)
            },
            None => None
        }

        /*
        if old_first.is_some() {
            //value = Some(old_first.unwrap().value);
            self.first = old_first.unwrap().next;
            //self.size -= 1;
        }
        */
    }

    /*
    pub fn get(&mut self, index: usize) -> Result<Option<&T>> {
        if index < self.size {
            return Err(anyhow!("The index requested is bigger than the list"));
        }

        let mut i: usize = 0;

        let mut value: Option<&T> = None;
        let mut node: Option<Box<Node<T>>> = self.first;
        while i <= index && node.is_some() {
            if i == index {
                value = Some(node.unwrap().value).as_ref();
                break;
            }
            else if node.is_some() && node.unwrap().next.is_some() {
                node = node.unwrap().next;
            }
            else {
                panic!("Unable to find node at index {}", index);
            }

            i += 1;
        }
        
        Ok(value)
    }
    
    // Add a node at index "i"
    pub fn add(&mut self, index: usize, value: T) -> Result<()> {
        if index > self.size {
            return Err(anyhow!("The index requested is bigger than the list"));
        }

        let new_node: Option<Box<Node<T>>> = Some(Box::new(Node::<T>::new(value, None)));

        if self.first.is_none() {
            self.first = new_node;
        } else {
            let mut node: Box<Node<T>> = self.first.unwrap();
            let mut prev_node: Box<Node<T>> = node;
            let mut next_node: Box<Node<T>> = node;
            let mut i = 0;

            while node.next.is_some() && i < index {
                prev_node = node;
                node = node.next.unwrap();
                next_node = node;

                i += 1;
            }

            new_node.unwrap().next = Some(node);
            prev_node.next = new_node;
            
            if next_node.next.is_none() {
                self.last = Some(node);
            } else {
                node.next = Some(next_node);
            }
        }

        Ok(())
    }
    */
}

impl<T> Drop for LinkedList<T> {
    fn drop(&mut self) {
        let mut current_node = mem::replace(&mut self.first, None);

        while current_node.is_some() {
            current_node = mem::replace(&mut current_node.unwrap().next, None);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_have_1_node() {
        let value: u32 = 1;

        let list = LinkedList::new(Some(value));
        let first_value = list.first.as_ref().unwrap().value;
        //let last_value = list.last.unwrap().value;
        //assert_eq!(first_value, last_value);
        assert_eq!(first_value, 1);
        //assert_eq!(last_value, 1);
        assert_eq!(list.size, 1);
    }

    /*
    #[test]
    fn should_get_first_value() {
        let mut list = LinkedList::new(Some(String::from("a")));
        let value: Option<&String> = list.get(0).unwrap();

        assert_eq!(value.unwrap(), &String::from("a"));
        assert_ne!(value.unwrap(), &String::from("b"));
    }

    #[test]
    fn should_not_get_index_out_of_bounds() {
        let mut list = LinkedList::new(Some(1.0));
        let result: Result<Option<&f32>> = list.get(1);

        assert!(result.is_err());
    }
    */

    #[test]
    fn should_add_and_remove_first() {
        let value: u8 = 1;

        let mut list = LinkedList::new(Some(value));
        _ = list.add_first(2);
        _ = list.add_first(3);

        assert_eq!(list.first.as_ref().unwrap().value, 3);
        assert_eq!(list.remove_first(), Some(3));
        assert_eq!(list.remove_first(), Some(2));
        assert_eq!(list.remove_first(), Some(1));
        assert_eq!(list.remove_first(), None);
    }
}
