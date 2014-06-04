class RSpecJUnitFormatter < RSpec::Core::Formatters::BaseFormatter
  attr_reader :started

  def start(example_count)
    @started = Time.now
    super
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    super
    xml_dump
  end

private

  def xml_dump_examples
    examples.each do |example|
      send :"xml_dump_#{example.execution_result[:status]}", example
    end
  end

  def result_of(example)
    example.execution_result[:status]
  end

  def classname_for(example)
    example.file_path.sub(%r{\.[^/]*\Z}, "").gsub("/", ".").gsub(%r{\A\.+|\.+\Z}, "")
  end

  def duration_for(example)
    example.execution_result[:run_time]
  end

  def description_for(example)
    example.full_description
  end

  def exception_for(example)
    example.execution_result[:exception]
  end

  def formatted_backtrace_for(example)
    format_backtrace exception_for(example).backtrace, example
  end
end
