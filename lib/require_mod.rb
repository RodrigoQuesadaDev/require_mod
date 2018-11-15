require "require_mod/version"
require 'pathname'

module RequireMod

  module Regex
    RUBY_FILE = /\.rb$/
  end
  private_constant :Regex

  class << self
    def _require_single_mod(mod)
      require_children Pathname.new('lib') / mod
    end

    private

    def require_children dir
      mod_file = dir / 'module.rb'
      require mod_file.expand_path if mod_file.exist?

      files, sub_dirs = dir.children.sort.partition(&:file?)

      files.to_enum
          .map { |it| it.expand_path.to_s }
          .grep(Regex::RUBY_FILE)
          .each { |it| require it }

      sub_dirs.each { |it| require_children it }
    end

    def require(file)
      Kernel.send(:require, file)
    end
  end

  def require_mod(*mods)
    mods.each { |it| RequireMod._require_single_mod it }
    nil
  end
end

include RequireMod