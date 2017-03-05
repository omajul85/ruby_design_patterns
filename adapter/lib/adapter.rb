# Software adapters allow us to bridge the gap between mistmatching
# software interfaces. An adapter is an object that crosses the
# chasm between the interface that you have and the interface
# that you need.

class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      clear_char = reader.getc
      encrypted_char = clear_char ^ @key[key_index].to_s
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end

reader = File.open('message.txt')
writer = File.open('encrypted_message.txt', 'w')
encrypter = Encrypter.new('my secret key')
encrypter.encrypt(reader, writer)

# What happens if the data we want to secure is inside a String
# rather than in a file?.
# We need an obj that looks like and open file on the outside
# but actually gets its characters from the String on the inside.
# We need a StringIOAdapter

class StringIOAdapter
  def initialize(string)
    @string = string
    @position = 0
  end

  def getc
    raise EOFError if eof?
    @string[@position]
  end

  def eof?
    @position >= @string.length
  end
end

# To use Encrypter with StringIOAdapter, we just have to replace
# the input file with an Adapter:

reader = StringIOAdapter('We attack at dawn')
writer = File.open('output.txt', 'w')
encrypter = Encrypter.new('XYZ')
encrypter.encrypt(reader, writer)