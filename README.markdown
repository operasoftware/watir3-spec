Watir 3 Specification
=====================

This repository contains a proposal for the successor to the current
[Watir API](http://wiki.openqa.org/display/WTR/Summary) (version 1).  It
is still in development, and we welcome any feedback on our [mailing
list](https://list.opera.com/mailman/listinfo/operawatir-users).

The first generation Watir API suffers from a lack consistency and
from not being easily extendible in special cases.  Some of these issues
were addressed in the second generation API, Watir 2, by Jari Bakken and
his watir-webdriver implementation.  However, even with full HTML 5
compliancy, it was still hard to access all elements and attributes
present in the DOM.

Watir 3 is the next generation specification aiming to keep the methods
as consistent as possible, i.e. no special cases, such as `browser.link`
in Watir 1, and to make the common case as simple and as concise as
possible.

This specification can be extended by a Watir 2 implementation, which
again can be extended by a Watir 1 implementation.  This means that we
in the future can be able to support _all three_ API versions in the
same code base.  This work is unfortunately still a work in progress.

This specification is so far implemented by
[OperaWatir](https://github.com/operasoftware/operawatir).

Dependencies
------------

The specs run a small Sinatra webapp (_WatirSpec::Server_) to simulate
interacting with a web server.  However, most specs use the _file://_
scheme to avoid hitting the server.

A quick guide
-------------

Start with

    window = OperaWatir::Browser.new.window

Find all `<div>` tags with

    window.div # => Collection of <div>s
    window.find_by_tag(:div) # => Array of <div>s

Find all `<a href="index.html">` links with

    window.a(:href => 'index.html') # => Collection of <a>s with the href attribute equal to 'index.html'

Find all `<p>`s which are direct descendants of `<div>`s with (not currently implemented)

    window.div.p # => Collection of <p>s

Get attributes with

    window.div(:id => 'logo').id # => 'logo'
    window.div(:title => 'Products').title # => ['Products', 'Products', …]

Perform actions with gusto!

    window.div.click # clicks all the <div>s in the document
    window.header.trigger :onMouseMove # triggers a mouse move event on all the <header> elements

Use filters to narrow down your search to find elements like `<div
id='foo' class='bar'>`:

    window.div(:id => 'foo', :class => 'bar')

Find invalid elements with any tag name and any attribute name, just
like in jQuery.  This will find `<foo bar='baz' bah='Hello!'>`:

    window.foo(:bar => 'baz').bah # => 'Hello!'

