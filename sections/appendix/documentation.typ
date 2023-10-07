#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Documentation")
Next to this document, both ReSet and ReSet-Daemon will have their code
documented using the rustdoc functionality. This allows inline documentation,
which will later be converted to an HTML file.\

The documentation for both the API to interact with ReSet-Daemon and the API for
the plugin system will also be handled with this method. It allows for dynamic
documentation that can be changed directly inside the code. With cargo test, one
can even create documentation tests, making sure that all examples work before
releasing a new version.

// typstfmt::off
#figure(
  [ #sourcecode(
      ```rs
      /// # Examples
      /// takes a number and multiplies it with itself x(positive) amount of times.
      /// '''
      /// use test_package::pfact;
      /// let num = pfact(2,3);
      /// assert_eq!(8, num);
      /// '''
      pub fn pfact(number: i32, exponent: u32) -> i32 {
          if exponent == 0 {
              return 1;
          }
          if exponent == 1 {
              return number;
          }
          let mut result = number;
          for _ in 1..exponent {
              result = result * number;
          }
          result
      }
      ```,
    )
    #align(center, image("../../figures/rustdoc.png"))
    #align(center, image("../../figures/rustdoc_test.png")) ],
  caption: [Rustdoc example entry for code above.],
)<rustdoc>
// typstfmt::on
