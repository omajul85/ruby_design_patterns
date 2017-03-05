# The Commands pattern

require 'fileutils'

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

  def unexecute
    File.delete(@path)
  end
end

# We might also need a command to delete a file

class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
  end

  def execute
    if File.exists?(@path)
      @contents = File.read(@path)
    end
    File.delete(@path)
  end

  def unexecute
    if @contents
      f = File.open(@path, 'w')
      f.write(@contents)
      f.close
    end
  end
end

# Command to copy one file to another

class CopyFile < Command
  def initialize(src, dst)
    super("Copy file: #{src} to #{dst}")
    @src = src
    @dst = dst
  end

  def execute
    if File.exists?(@dst)
      @contents = File.read(@dst)
    end
    FileUtils.copy(@src, @dst)
  end

  def unexecute
    if @contents
      f = File.open(@dst, 'w')
      f.write(@contents)
      f.close
    end
  end
end

# We need a class to collect ALL of our commands. A class
# that acts like a command but really is just a front for
# a number of subcommands. Sounds like a COMPOSITE.

class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def add_command(cmd)
    @commands << cmd
  end

  def execute
    @commands.each { |cmd| cmd.execute }
  end

  def unexecute
    @commands.reverse.each { |cmd| cmd.unexecute }
  end

  def description
    description = ""
    @commands.each { |cmd| description += cmd.description + '\n' }
    description
  end
end

# CompositeCommand allows us to tell the user exactly what we are
# doing. We could for example create a new file, copy it to a 2nd
# file and then delete the 1st file:

cmds = CompositeCommand.new

cmds.add_command(CreateFile.new('file1.txt', 'Hello World'))
cmds.add_command(CopyFile.new('file1.txt', 'file2.txt'))
cmds.add_command(DeleteFile.new('file1.txt'))

# To execute ALL of these stuff, we simply call execute:

cmds.execute

# To explain the user what is happening

p cmds.description

# Tips
# Queuing up commands: A wizard can be a list of commands.