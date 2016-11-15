class ArrayIterator
  def initialize(array)
    @array = array
    @index = 0
  end

  def has_next?
    @index < @array.length
  end

  def item
    @array[@index]
  end

  def next_item
    value = item
    @index += 1
    value
  end
end

ary = %w(one two three)
i = ArrayIterator.new ary
while i.has_next?
  puts "item: #{i.next_item}"
end
