#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Documentation")
Next to this document, both ReSet and ReSet-Daemon will have their code
documented using the rustdoc functionality.\
This allows inline documentation, which will later be converted to an HTML file.\
The API for ReSet-Daemon will be covered under TBD.

// typstfmt::off
#figure(
  [ #sourcecode(
      ```rs
      /// takes a number and multiplies it with itself x(positive) amount of times.
      /// ‘‘‘
      /// let num = fact(3,2);
      /// assert_eq!(9, numb);
      /// ‘‘‘
      fn pfact(number: i32, exponent: u32) -> i32 {
          if exponent == 0 {
              return 1;
          }
          if exponent == 1 {
              return number;
          }
          let mut result = number;
          for _ in 2..exponent {
              result = result * number;
          }
          result
      }
      ```,
    )
    #align(center, image("../../figures/rustdoc.png", width: 100%)) ],
  caption: [Rustdoc example entry for code above.],
)<rustdoc>
// typstfmt::on
