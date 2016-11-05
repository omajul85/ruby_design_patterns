# The Strategy pattern:
# - pull the algorithm out into a separate object
# - Is based on composition and delegation
# - It is easy to switch strategies at runtime. We simply swap out the strategy object

# Strategy objects aka strategies all do the same thing, in this case format the report

# Ruby code blocks, which are essentially code wrapped up in an instant object (the Proc object),
# are wonderfully useful for creating quick, albeit simple, strategy objects.

html_formatter = lambda do |context|
  puts('<html>')
  puts('  <head>')
  puts("    <title>#{context.title}</title>")
  puts('  </head>')
  puts('  <body>')
  context.text.each do |line|
    puts("    <p>#{line}</p>" )
  end
  puts('  </body>')
  puts('</html>')
end

plain_text_formatter = lambda do |context|
  puts("***** #{context.title} *****")
  context.text.each do |line|
    puts line
  end
end

# Now that we have completely removed the details of formatting the output
# from our Report class, that class becomes much simpler:

# This class is called 'The Context'
class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(&formatter)
    @title = 'Monthly Report'
    @text = ['Things are going', 'really, really well.']
    @formatter = formatter
  end

  def output_report
    @formatter.call(self)
  end
end

# Given that we have a Proc object and the Report constructor expects a code block,
# we need to stick an ampersand in front of our Proc object when we create a new Report instance:

report = Report.new(&html_formatter)
report.output_report

# Update the proc
report.formatter = plain_text_formatter
report.output_report

# Change the formater on the fly!
report = Report.new do |context|
  puts('html')
  puts('  head')
  puts("    title = #{context.title}")
  puts('  body')
  context.text.each do |line|
    puts("    p = #{line}")
  end
end
report.output_report
