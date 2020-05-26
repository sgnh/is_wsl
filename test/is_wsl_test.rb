# frozen_string_literal: true

require 'test_helper'

class IsWslTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::IsWsl::VERSION
  end

  def test_wsl_is_false_on_docker
    IsDocker.stub(:docker?, true) do
      assert IsWsl.wsl? == false
    end
  end

  def test_wsl_is_true_on_WSL1
    stub = proc { |args| args == '/proc/version' ? ['Microsoft'] : (raise Errno::ENOENT) }

    File.stub(:readlines, stub) do
      assert IsWsl.wsl? == true
    end
  end

  def test_wsl_is_true_on_WSL2
    stub = proc { |args| args == '/proc/version' ? ['microsoft'] : (raise Errno::ENOENT) }

    File.stub(:readlines, stub) do
      assert IsWsl.wsl? == true
    end
  end

  def test_wsl_is_false_on_linux
    stub = proc { |args| args == '/proc/version' ? ['linux'] : (raise Errno::ENOENT) }

    File.stub(:readlines, stub) do
      assert IsWsl.wsl? == false
    end
  end

  def test_wsl_is_false_without_version
    File.stub(:readlines, proc { raise Errno::ENOENT }) do
      assert IsWsl.wsl? == false
    end
  end
end
