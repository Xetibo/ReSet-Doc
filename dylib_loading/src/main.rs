use std::{io, thread};

fn main() {
    thread::spawn(|| {
        load_dylib();
    });
    // program should still get this input even if the thread crashes
    let mut buffer = String::new();
    io::stdin().read_line(&mut buffer);
}

fn load_dylib() {
    unsafe {
        let lib = libloading::Library::new("./testlib/target/debug/libtestlib.so")
            .expect("Could not open library.");
        let func: libloading::Symbol<unsafe extern "C" fn(i32) -> i32> =
            lib.get(b"non_existant").expect("Could not load function.");
        assert_eq!(func(2), 4);
        println!("success");
    }
}

// fn main() {
//     unsafe {
//         let lib = libloading::Library::new("./testlib/target/debug/libtestlib.so")
//             .expect("Could not open library.");
//         let func: libloading::Symbol<unsafe extern "C" fn(i32) -> i32> =
//             lib.get(b"test_function").expect("Could not load function.");
//         assert_eq!(func(2), 4);
//         println!("success");
//     }
// }
