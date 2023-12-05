#import "../templates/utils.typ": *
#lsp_placate()

#section("Conclusion")

#subsection("UI Design Result")
The final UI design has generally followed our intended vision. The UI is clean and simple, and the user can easily navigate through the UI. It is also responsive, which means that it will adjust itself depending on window sizes.

But there are some things that didn't make it into the final design. The first one is the breadcrumb menu. It was decided that the breadcrumb menu is not necessary because our UI isn't as nested as we thought initially. The depth of our UI is only one level deep, which means that a breadcrumb bar would be redundant. If we ever reach a point where we have a deeply nested UI, we will reconsider adding a breadcrumb menu. 
The other one is shortcuts. While there are some built-in shortcuts provided by GTK, we didn't add any of our own. This is because we didn't have enough time to implement them, but we will add them in the future.

#subsection("Further Potential")
