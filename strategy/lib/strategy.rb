# The Strategy pattern:
# - pull the algorithm out into a separate object
# - Is based on composition and delegation
# - It is easy to switch strategies at runtime. We simply swap out the strategy object

class Formatter
  def output_report(context)
    raise 'Abstract method caled'
  end
end

# Strategy objects aka strategies all do the same thing, in this case format the report

class HTMLFormatter < Formatter
  def output_report(context)
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
end

class PlainTextFormatter < Formatter
  def output_report(context)
    puts("***** #{context.title} *****")
    context.text.each do |line|
      puts line
    end
  end
end

# Now that we have completely removed the details of formatting the output
# from our Report class, that class becomes much simpler:

# This class is called 'The Context'
class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = 'Monthly Report'
    @text = ['Things are going', 'really, really well.']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self)
  end
end

report = Report.new(HTMLFormatter.new)
report.output_report

report.formatter = PlainTextFormatter.new
report.output_report
