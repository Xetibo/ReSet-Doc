fn main() {
    let penguin = Example {
        name: "penguin".to_string(),
        age: 29,
    };
    let any_penguin = penguin.to_any();
    let restored_penguin = Example::from_any(any_penguin);
    assert_eq!(penguin, restored_penguin);
    println!("Success");
}

trait AnyImpl {
    fn to_any(&self) -> Any;
    fn from_any(any: Any) -> Self;
}

struct Any {
    // holds the data of all fields
    data: Vec<u8>,
    // determinant splits data vector back to fields
    determinants: Vec<usize>,
}

#[derive(PartialEq, Eq, Debug)]
struct Example {
    name: String,
    age: u32,
}

impl AnyImpl for Example {
    // This is just an example, could also be done with a Hashmap or similar
    fn to_any(&self) -> Any {
        let data = self.name.as_bytes();
        let determinants = vec![data.len()];
        let data = [data, &self.age.to_ne_bytes()].concat();
        Any { data, determinants }
    }

    fn from_any(any: Any) -> Self {
        let (name, age) = any.data.split_at(*any.determinants.last().unwrap());
        let name = String::from_utf8(name.to_vec()).unwrap();
        let age = u32::from_ne_bytes(age.try_into().unwrap());
        Self { name, age }
    }
}
