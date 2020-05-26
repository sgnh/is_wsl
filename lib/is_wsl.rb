# frozen_string_literal: true

require 'is_wsl/version'
require 'is_docker'

module IsWsl
  def self.wsl?
    !IsDocker.docker? &&
      !File.readlines('/proc/version').grep(/microsoft/i).empty?
  rescue Errno::ENOENT
    false
  end
end
