use steel::steel_vm::engine::Engine;
use steel::steel_vm::register_fn::RegisterFn;

fn main() {
    let mut vm = Engine::new();
    vm.register_fn("test-function", test_function);
    vm.run("(test-function)").unwrap();
}

fn test_function() {
    println!("this is a test");
}

