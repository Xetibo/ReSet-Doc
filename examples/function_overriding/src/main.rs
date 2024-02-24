use once_cell::sync::Lazy;
static mut G_PLUGIN_SYSTEM: Lazy<PluginSystem> = Lazy::new(|| PluginSystem {
    function: Box::new(regular_function),
});

fn main() {
    // The reason for unsafe is the mutability with different threads.
    // With static variables it is possible to access the same Plugin System at the same time.
    // For a real system with different threads, it would be required to put mutable access behind
    // a locking mechanism.
    unsafe {
        G_PLUGIN_SYSTEM.call(5);
        // this override can be done with a dynamic library or IPC
        G_PLUGIN_SYSTEM.override_function(second_function);
        G_PLUGIN_SYSTEM.call(5);
    }
}

fn regular_function(data: i32) {
    println!("This is the first function: {}", data);
}

fn second_function(data: i32) {
    println!("This is the second function: {}", data);
}

struct PluginSystem {
    function: Box<fn(i32)>,
}

impl PluginSystem {
    fn override_function(&mut self, new_function: fn(i32)) {
        self.function = Box::new(new_function);
    }

    fn call(&self, data: i32) {
        (self.function)(data);
    }
}
