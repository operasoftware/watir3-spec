Opera's new Watir spec
======================

This repository contains a specification for a proposed successor to the
current [Watir API](http://wiki.openqa.org/display/WTR/Summary). It is still in
development, and we welcome any feedback on our
[mailing list](https://list.opera.com/mailman/listinfo/operawatir-users).

We aimed to keep the methods as consistent as possible, i.e. no special cases,
such as `browser.link` in Watir 1, and to make the common case as simple and as
concise as possible.

Files
-----

The specs are in `browser_spec.rb`, `window_spec.rb`, `collection_spec.rb` and
`element_spec.rb`.

The specs run a small Sinatra webapp (_WatirSpec::Server_) to simulate
interacting with a web server. However, most specs use the _file://_ scheme to
avoid hitting the server.

A quick guide
-------------

Start with

    window = OperaWatir::Browser.new().active_window

Find all `<div>` tags with

    window.div # => Collection of <div>s
    window.find_by_tag(:div) # => Collection of <div>s

Find all `<a href="index.html">` links with

    window.a(:href => 'index.html') # => Collection of <a>s with the href attribute equal to 'index.html'

Find all `<p>`s which are direct descendants of `<div>`s with (not currently implemented)

    window.div.p # => Collection of <p>s

Get attributes with

    window.div(:id => 'logo').id # => 'logo'
    window.div(:title => 'Products').title # => ['Products', 'Products', …]

Perform actions with gusto!

    window.div.click! # clicks all the <div>s in the document
    window.header.trigger! 'mousemove' # triggers a mouse move event on all the <header> elements
