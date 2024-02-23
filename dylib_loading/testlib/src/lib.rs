#[no_mangle]
pub extern "C" fn test_function(data: i32) -> i32 {
    data * data
}

#[no_mangle]
pub extern "C" fn test_function2(var: i32) {
    unsafe {
        TESTVAR += var;
        println!("{TESTVAR}");
    }
}

#[no_mangle]
static mut TESTVAR: i32 = 0;
