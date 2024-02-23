#import "../../templates/utils.typ": *

#figure(sourcecode(```rs
use std::ffi::{c_void, CString};

#[no_mangle]
pub extern "C" fn pluginAPIVersion() -> String {
    String::from("0.1")
}

#[no_mangle]
pub extern "C" fn pluginInit(_handle: *const c_void) -> PLUGIN_DESCRIPTION_INFO {
    println!("start plugin");
    PLUGIN_DESCRIPTION_INFO {
        name: CString::new("RustPlugin")
            .expect("Could not convert to CString.")
            .into_raw(),
        description: CString::new("This is insane!")
            .expect("Could not convert to CString.")
            .into_raw(),
        author: CString::new("Xetibo")
            .expect("Could not convert to CString.")
            .into_raw(),
        version: CString::new("0.1")
            .expect("Could not convert to CString.")
            .into_raw(),
    }
}

#[no_mangle]
pub extern "C" fn pluginExit() {
    println!("exit plugin");
}

#[allow(non_camel_case_types)]
#[repr(C)]
pub struct PLUGIN_DESCRIPTION_INFO {
    name: *mut libc::c_char,
    description: *mut libc::c_char,
    author: *mut libc::c_char,
    version: *mut libc::c_char,
}
```), kind: "code", supplement: "Listing", caption: [Hyprland plugin in Rust])<hyprland_plugin_rust>
