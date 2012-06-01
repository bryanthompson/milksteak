module FragmentHelper
  def fragment(name)
    Milksteak::Fragment.render(name)
  end

  def hash_attribute(hash, name)
    if hash.keys.include?(name)
      return hash[name]
    elsif hash.keys.include?(name.to_sym)
      return hash[name.to_sym]
    else
      nil
    end
  end

  def inspect(obj)
    return obj.inspect
  end
end

Liquid::Template.register_filter(FragmentHelper)
