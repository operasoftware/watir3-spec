describe "Collection" do
  before :each do
    browser.goto(fixture('non_control_elements.html'))
    @collection = window.div
  end

  # tag(what, *conditions)

  # attrs(what)

  # style

  # states
  # ------

  # checked?
  # check!
  # uncheck!
  # toggle_check!

  # enabled?
  # enable!
  # disable!

  # visible?
  # show!
  # hide!

end
