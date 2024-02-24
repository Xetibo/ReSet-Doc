pub mod namespace1;
pub mod namespace2;

fn main() {
    let _res1 = namespace1::add(5, 2);
    let _res2 = namespace2::add(5, 2);
    // these get flattened to add and subtract
}


