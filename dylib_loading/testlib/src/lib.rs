#[no_mangle]
pub extern "C" fn test_function(data: i32) -> i32 {
    data * data
}
