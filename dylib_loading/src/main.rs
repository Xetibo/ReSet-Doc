fn main() {
    unsafe {
        let lib = libloading::Library::new("./testlib/target/debug/libtestlib.so")
            .expect("Could not open library.");
        let func: libloading::Symbol<unsafe extern "C" fn(i32) -> i32> =
            lib.get(b"test_function").expect("Could not load function.");
        assert_eq!(func(2), 4);
        println!("success");
    }
}
