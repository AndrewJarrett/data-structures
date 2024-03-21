use anyhow::{Result, anyhow};

#[derive(Debug)]
pub struct Node<'a, T> {
    next: Option<Box<&'a Node<'a, T>>>,
    value: T,
}

impl<'a, T> Node<'a, T> {
    pub fn new(value: T, next: Option<Box<&'a Node<T>>>) -> Self {
        Self {
            next,
            value,
        }
    }
}

#[derive(Debug)]
pub struct LinkedList<'a, T> {
    first: Option<Box<&'a Node<'a, T>>>,
    last: Option<Box<&'a Node<'a, T>>>,
    size: usize,
}

impl<'a, T> LinkedList<'a, T> {
    pub fn new(value: Option<T>) -> Self {
        let mut node: Option<Box<&'a Node<T>>> = None;
        let size = 0;

        match value {
            Some(value) => {
                node = Some(Box::new(&Node::<T>::new(value, None)));
            },
            None => {}
        }

        Self {
            first: node,
            last: node,
            size,
        }
    }

    pub fn add_first(&mut self, value: T) -> Result<()> {
        let mut node: Option<Box<&'a Node<T>>> = Some(Box::new(&Node::<T>::new(value, None)));
        node.expect("New node was not successfully created.").next = self.first;
        self.first = node;

        Ok(())
    }

    pub fn get(&mut self, index: usize) -> Result<Option<&T>> {
        if index < self.size {
            return Err(anyhow!("The index requested is bigger than the list"));
        }

        let mut i: usize = 0;

        let mut value: Option<&T> = None;
        let mut node: Option<Box<&'a Node<T>>> = self.first;
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
    pub fn add(&mut self, index: usize, value: T) -> Result<&Self> {
        if index > self.size {
            return Err(anyhow!("The index requested is bigger than the list"));
        }

        let new_node: Option<Box<&'a Node<T>>> = Some(Box::new(&Node::<T>::new(value, None)));

        if self.first.is_none() {
            self.first = new_node;
        } else {
            let mut node: &'a Node<T> = self.first.unwrap().as_ref();
            let mut prev_node: &'a Node<T> = node;
            let mut next_node: &'a Node<T> = node;
            let mut i = 0;

            while node.next.is_some() && i < index {
                prev_node = node;
                node = &node.next.unwrap();
                next_node = node;

                i += 1;
            }

            new_node.unwrap().next = Some(Box::new(&node));
            prev_node.next = new_node;
            
            if next_node.next.is_none() {
                self.last = Some(Box::new(node));
            } else {
                node.next = Some(Box::new(next_node));
            }
        }

        Ok(&self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_have_1_node() {
        let value: u32 = 1;

        let list = LinkedList::new(Some(value));
        let first_value = list.first.unwrap().value;
        let last_value = list.last.unwrap().value;
        assert_eq!(first_value, last_value);
        assert_eq!(first_value, 1);
        assert_eq!(last_value, 1);
        assert_eq!(list.size, 1);
    }

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

    #[test]
    fn should_add_first() {
        let value: u8 = 1;

        let mut list = LinkedList::new(Some(value));
        _ = list.add_first(2);

        assert_eq!(list.first.unwrap().value, 2);
    }
}
