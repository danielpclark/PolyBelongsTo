require 'minitest/reporters'

class StyledReporter < Minitest::Reporters::SpecReporter
  # minitest-reporters methods for version 0.14.24
  def pass(suite, test, test_runner)
    common_print(suite, test, test_runner, :green, 'PASS')
  end

  def skip(suite, test, test_runner)
    common_print(suite, test, test_runner, :yellow, 'SKIP')
  end

  def failure(suite, test, test_runner)
    common_print(suite, test, test_runner, :red, 'FAIL')
    print_exception(test_runner.exception)
  end

  def error(suite, test, test_runner)
    common_print(suite, test, test_runner, :red, 'ERROR')
    print_exception(test_runner.exception)
  end

  # Just in case we load a more recent minitest-reporters v1
  def record(test)
    super
    print pad_test(test.name) if test.failure
    print_colored_status(test)
    print(" (%.2fs)" % test.time)
    print " :: #{test.name}" unless test.failure
    puts
    if !test.skipped? && test.failure
      print_info(test.failure)
      puts
    end
  end

  private
  def common_print(suite, test, test_runner, color, message)
    print_suite(suite) unless @suites.include?(suite)
    print pad_test(test) if color.eql?(:red)
    print( send(color) { pad_mark(message) } )
    print_time(test)
    print " :: #{test}" unless color.eql?(:red)
    puts
  end

  def print_exception(ex)
    print_info(ex)
    puts
  end

end

