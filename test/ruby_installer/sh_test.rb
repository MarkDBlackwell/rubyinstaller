# coding: utf-8
require ::File.expand_path ::File.join((::File.dirname __FILE__), 'test_helper')

require 'pp'

class ::RubyInstaller::ShTest < ::Minitest::Test
  include ::RubyInstaller
  include ::FileUtils

  def test_if_a_command_exits_with_error_status_it_fully_echoes_it
    commands.each                 do |command|
      assert_standard_with_error_exit command
    end
  end

  def test_if_a_command_exits_with_error_status_it_raises_a_runtime_error
    commands.each                        do |command|
      exception = assert_raises RuntimeError do
        capture_total_output with_error_exit command
      end
##    expected = %Q@Command failed with status (1): [#{command[0, 42] + '...'}]@
      expected = %Q@Command failed with status (1): [#{command}]@
      assert_equal expected, exception.message
    end
  end

  def test_if_a_command_writes_to_standard_error_it_prints_that
    command =      to_standard_error              command_short
    ##         Stdout,      Stderr:
    expected =     '', "#{some_error_sentence}\n#{command}\n"
    assert_total_output expected,                 command
  end

  def test_if_a_command_writes_to_standard_output_it_prints_that
    command  = to_standard_output                  command_short
    ##                  Stdout,                    Stderr:
    expected =     "#{some_output_sentence}\n", "#{command}\n"
    assert_total_output expected,                  command
  end

  def test_if_a_command_writes_to_standard_output_and_standard_error_it_prints_that
    command  = to_standard_output           to_standard_error              command_short
    ##                  Stdout,                      Stderr:
    expected =     "#{some_output_sentence}\n", "#{some_error_sentence}\n#{command}\n"
    assert_total_output expected,                                          command
  end

  def test_it_fully_echoes_commands
    commands.each      do |command|
      assert_standard      command
    end
  end

  private

  def assert_standard(            command)
    expected_stdout = ''
    expected_stderr =             command + "\n"
    expected = [expected_stdout, expected_stderr]
    actual = capture_total_output command
    assert_equal expected, actual
    nil
  end

  def assert_standard_with_error_exit(command)
    begin
      assert_standard with_error_exit command
    rescue RuntimeError
    end
    nil
  end

  def assert_total_output(expected, command)
    actual = capture_total_output   command
    assert_equal          expected, actual
    nil
  end

  def capture_total_output(command)
puts 'just before'
    capture_subprocess_io do
##    %x(cat junk)

      m = method :sh
pp m
print 'm.owner='; p m.owner
print 'm.owner.ancestors='; p m.owner.ancestors
print 'm.receiver='; p m.receiver
print 'm.source_location='; p m.source_location
print 'm.original_name='; p m.original_name

#     sh(                   command) {}
      sh                    command
    end
  end

  def insert(command, string) command.insert((-2), string) end

  def command_long
    string = '1234567890' * 10
    %Q(ruby -e'v = "#{string}"')
  end

  def command_short() %Q(ruby -e'v="a"') end

  def commands() [command_long, command_short] end

  def some_error_sentence() 'Some error sentence.' end

  def some_output_sentence() 'Some output sentence.' end

  def to_standard_error(command)
    string = %Q(; $stderr.puts "#{some_error_sentence}")
    insert              command, string
  end

  def to_standard_output(command)
    string = %Q(; $stdout.puts "#{some_output_sentence}")
    insert               command, string
  end

  def with_error_exit(command)
    string = '; ::Kernel.exit false'
    insert            command, string
  end
end
