# frozen_string_literal: true

module Joi
  class CLI
    attr_reader :argv

    def initialize(argv = ARGV.dup)
      @argv = argv
    end

    def dot_rails_file?
      File.file?(File.join(Dir.pwd, ".rails"))
    end

    def gemfile?
      File.file?(File.join(Dir.pwd, "Gemfile")) ||
        File.file?(File.join(Dir.pwd, "gems.rb"))
    end

    def options
      @options ||= {
        rails: dot_rails_file?,
        bundler: gemfile?,
        debug: false
      }
    end

    def start
      OptionParser.new do |parser|
        parser.banner = "Usage: joi [OPTIONS]"
        parser.version = VERSION

        parser.on("--[no-]bundler", "-b",
                  "Use bundler to run commands.") do |bundler|
          options[:bundler] = bundler
        end

        parser.on("--rails", "Use this in Rails projects.") do |rails|
          options[:rails] = rails
        end

        parser.on("--debug", "Enable debug output.") do |debug|
          options[:debug] = debug
        end

        parser.on("-h", "--help", "Prints this help.") do
          puts parser
          exit
        end

        parser.parse!(argv)

        runner = Runner.new(options: options)

        runner.debug(".rails file found?", dot_rails_file?)
        runner.debug("options:", options)

        trap("INT") { runner.run_all }
        trap("QUIT") { exit! }

        runner.start
      end
    end
  end
end
