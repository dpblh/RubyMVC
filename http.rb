require 'erb'

class ShoppingList
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  # Expose private binding() method.
  def get_binding
    binding()
  end

end
items = 'tim'
template = 'hello, <%= @items %>'
list = ShoppingList.new(items)
renderer = ERB.new(template)
puts output = renderer.result(list.get_binding)