use anyhow::{Result, anyhow};

#[derive(Clone, Debug)]
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
    first: &'a Node<'a, T>,
    last: &'a Node<'a, T>,
    size: usize,
}

impl<'a, T> LinkedList<'a, T> {
    pub fn new(node: &'a Node<T>) -> Self {
        Self {
            first: node,
            last: node,
            size: 1,
        }
    }

    pub fn get(&mut self, index: usize) -> Result<&T> {
        if index < self.size {
            return Err(anyhow!("The index requested is bigger than the list"));
        }

        let mut i: usize = 0;

        let mut node: &Node<T> = &self.first;
        let mut value: &T = &node.value;
        while i <= index {
            if i == index {
                value = &node.value;
                break;
            }
            else if node.next.is_some() {
                node = &node.next.as_ref().unwrap();//.expect("Expected to find a next node!");
            }
            else {
                panic!("Unable to find node at index {}", index);
            }

            i += 1;
        }
        
        Ok(&value)
    }
    
    // Add a node at index "i"
    pub fn add(&mut self, index: usize, &new_node: &'a Node<T>) -> Result<&Self> {
        if index > self.size {
            return Err(anyhow!("The index requested is bigger than the list"));
        }

        let mut node: &Node<T> = &self.first;
        let mut prev_node: &Node<T> = &self.first;
        let mut next_node: &Node<T> = &self.first;
        let mut i = 0;

        while node.next.is_some() && i < index {
            prev_node = &node;
            node = &node.next.as_ref().unwrap();
            next_node = &node.next.as_ref().unwrap();

            i += 1;
        }

        if index == 0 {
            self.first = &node;
            node.next = Some(Box::new(&next_node));
        }

        prev_node.next = Some(Box::new(&node));
        
        if !next_node.is_some() {
            self.last = &node;
        }
        else {
            node.next = Some(Box::new(&next_node));
        }

        Ok(&self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_have_1_node() {
        let node: Node<u32> = Node::<u32>::new(1, None);

        let list = LinkedList::new(&node);
        assert_eq!(list.first.value, list.last.value);
        assert_eq!(list.first.value, 1);
        assert_eq!(list.last.value, 1);
        assert_eq!(list.size, 1);
    }

    #[test]
    fn should_get_first_value() {
        let node: Node<String> = Node::<String>::new(String::from("a"), None);

        let mut list = LinkedList::new(&node);
        let value: &String = list.get(0).unwrap();

        assert_eq!(value, &String::from("a"));
        assert_ne!(value, &String::from("b"));
    }

    #[test]
    fn should_not_get_index_out_of_bounds() {
        let node: Node<f32> = Node::<f32>::new(1.0, None);

        let mut list = LinkedList::new(&node);
        let result: Result<&f32> = list.get(1);

        assert!(result.is_err());
    }
}
