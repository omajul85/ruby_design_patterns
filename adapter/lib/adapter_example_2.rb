# Perhaps the most frustrating situations that seem to call for
# an Adapter are those where the interface you have almost
# lines up with the interface that you need. Ex:

class Renderer
  def render(text_obj)
    text = text_obj.text
    size = text_obj.size_inches
    color = text_obj.color

  # Render that text...
  end
end

# Clearly, Renderer is looking to render objects that look like

class TextObj
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text = text
    @size_inches = size_inches
    @color = color
  end
end

# Unfortunately, we discover that some of the text that we need
# to render is contained in an obj like:

class BritishTextObj
  attr_reader :string, :size_mm, :colour

  def initialize(string, size_mm, colour)
    @string = string
    @size_mm = size_mm
    @colour = colour
  end
end

# To fix these problems, we could break out the Adapter pattern

class BritishTextObjAdapter < TextObj
  def initialize(bto)
    @bto = bto
  end

  def text
    @bto.string
  end

  def size_inches
    @bto.size_mm / 25.4
  end

  def color
    @bto.colour
  end
end

# Maybe. Alternatively, we might choose to take advantage of
# Ruby's ability to modify a class on the fly.

# We add some methods to the original class (by reopening it)
class BritishTextObj
  def color
    colour
  end

  def text
    string
  end

  def size_inches
    size_mm / 25.4
  end
end

# MODIFYING A SINGLE INSTANCE

# If modifying an entire class on the fly seems a little extreme
# Ruby provides a less invasive alternative, SINGLETON classes:

bto = BritishTextObj.new('foo', 50.8, :pink)

class << bto
  def color
    colour
  end

  def text
    string
  end

  def size_inches
    size_mm / 25.4
  end
end