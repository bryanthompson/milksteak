module FragmentHelper
  def fragment(name)
    Milksteak::Fragment.render(name)
  end
end

Liquid::Template.register_filter(FragmentHelper)
