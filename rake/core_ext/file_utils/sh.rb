module ::RubyInstaller
  # Prints out the entire shell command, not merely a truncation of it,
  # even without 'rake --trace'.
  # This is especially useful for error exit.

# alias_method :orig_sh, :sh

  # On failure, show the full command.
  def sh(                  *cmd, &block)
fail
    ::FileUtilsExt.sh *cmd, &block
  end
=begin
#print 'block_given?='; p block_given?
print 'block='; p block
    # Rake has frozen $trace.
    # Therefore, changing its value won't work.
#   return orig_sh(        *cmd, &block) if block_given?
    return orig_sh(        *cmd, &block) if block
    show_the_full_command = cmd.join(" ")
    orig_sh(               *cmd) do |ok, status|
      ok or
        fail "Command failed with status (#{status.exitstatus}): " +
        "[#{show_the_full_command}]"
    end
  end

  def create_shell_runner(cmd)
    show_command = cmd.join(" ")
#   show_command = show_command[0, 42] + "..." unless $trace
    lambda do |ok, status|
      ok or
        fail "Command failed with status (#{status.exitstatus}): " +
        "[#{show_command}]"
    end
  end
  private :create_shell_runner
=end
end
