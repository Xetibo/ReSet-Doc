#import "../../templates/utils.typ": *
#lsp_placate()

#section("User Interface")
The user interface is built using the GTK compatible XML markup language. This
allows for a separated user interface definition which reduces code size and
keeps functionality away from design. Alongside this, XML also allows for use of
graphical tools in order to create the user interface itself, providing
immediate feedback about the style and feel of the design.

The binding of these definitions is handled via a GTK specific build.rs file,
which defines Gresources that will be integrated into the project. Gresources
represent a variety of tools and objects which can be used within the project,
such as user interface templates, icons, images and more.@gresources

#figure(sourcecode(```rs
fn main() {
    glib_build_tools::compile_resources(
        &["src/resources"],
        "src/resources/resources.gresource.xml",
        "src.templates.gresource",
    );
    glib_build_tools::compile_resources(
        &["src/resources/icons"],
        "src/resources/icons/resources.gresource.xml",
        "src.icons.gresource",
    );
    glib_build_tools::compile_resources(
        &["src/resources/style"],
        "src/resources/style/resources.gresource.xml",
        "src.style.gresource",
    );
}
```), caption: [Example build.rs for XML bindings in GTK])<build_rs>

For ReSet, the vast majority of the user interface is handled via XML
definitions, with only a fraction being inlined in the code. These inline
definitions are usually temporary containers, or need a more dynamic
functionality which is not directly available with XML.

The binding for XML to rust happens within regular rust files, with various GTK
macros being used. This means that one can use seemingly regular rust code,
which the gtk-rs library later restructures to GTK compatible code via rust
macros. Rust macros are metaprogramming, which means the rust toolchain will
change the code before compiling it into a binary. For rust this features
expands to allowing full rust code withing metaprogramming, making entire
programs possible at compile time.@rust_macros ReSet currently only uses this
feature via gtk-rs or via default macros provided by the standard library,
however it could become a vital tool for the creation of a plugin system which
is mentioned in @Conclusion.

#figure(
sourcecode(
// typstfmt::off
```rs
// an example macro from "The Rust Programming Language"
fn impl_hello_macro(ast: &syn::DeriveInput) -> TokenStream {
    let name = &ast.ident;
    let gen = quote! {
        impl HelloMacro for #name {
            fn hello_macro() {
                println!("Hello, Macro! My name is {}!", stringify!(#name));
            }
        }
    };
    gen.into()
}
```,
  ), caption: [An example macro from the book: "The Rust Programming Language"@rust_macros],
)<macro_example>

The binding itself is created via the PImpl(Pointer to Implemenation) idiom,
which allows for a generic implementation of an object without immediate
recompilation unless the object itself is changed. As defined by cppreference@pimpl@pimpl_gotw, this
idiom is usually applied in C++, but can also be used with rust, and is also
recommended to be used by an officially endorsed gtk-rs
introduction.@gtk_rs_introduction

#figure(
sourcecode(
// typstfmt::off
```rs
glib::wrapper! {
    pub struct ListEntry(ObjectSubclass<list_entry_impl::ListEntry>)
    // define GTK classes to inherit from
    @extends gtk::ListBoxRow, gtk::Widget,
    // define interfaces to implement
    @implements gtk::Accessible, gtk::Buildable, gtk::ConstraintTarget, gtk::Actionable;
}

impl ListEntry {
    pub fn new(child: &impl IsA<Widget>) -> Self {
        Object::builder().build()
    }
}
```,
  ), caption: [Example Pointer for an XML template],
)<pointer_xml>

In figure @pointer_xml, there are two structs with the name ListEntry,
the first is the pointer which holds generic GTK functionality,
in this case it will offer everything that the inherited classes provided,
as well as the implemented interfaces.
The second ListEntry is the implementation which will refer to the XML template.

#figure(
sourcecode(
// typstfmt::off
```rs
#[derive(Default, CompositeTemplate)]
#[template(resource = "/org/Xetibo/ReSet/resetListBoxRow.ui")]
pub struct ListEntry {
    #[template_child]
    // custom entries that will be included in the template
    pub example: TemplateChild<GTKTYPE>,
}

#[glib::object_subclass]
impl ObjectSubclass for ListEntry {
    const ABSTRACT: bool = false;
    // the name of the created GTK module
    const NAME: &'static str = "resetListBoxRow";
    // the pointer type
    type Type = list_entry::ListEntry;
    type ParentType = gtk::ListBoxRow;

    fn class_init(klass: &mut Self::Class) {
        // bind the template to this struct
        klass.bind_template();
    }

    fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
        obj.init_template();
    }
}

impl ObjectImpl for ListEntry {
    fn constructed(&self) {
        self.parent_constructed();
    }
}

// default implementations for interfaces
impl ListBoxRowImpl for ListEntry {}

impl WidgetImpl for ListEntry {}

impl WindowImpl for ListEntry {}

impl ApplicationWindowImpl for ListEntry {}
```,
  ), caption: [Example Implementation for an XML template],
)<implementation_xml>
