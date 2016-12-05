# The Commands pattern

# Base command class
class Command
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def execute
  end
end

# Next we have a command to create a file and write the contents
# of a string out to the new file

class CreateFile < Command
  def initialize(path, contents)
    super("Create file: #{path}")
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, 'w')
    f.write(@contents)
    f.close
  end
end
