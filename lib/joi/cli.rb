# frozen_string_literal: true

module Joi
  class CLI
    attr_reader :argv

    def initialize(argv = ARGV.dup)
      @argv = argv
    end

    def options
      @options ||= {
        rails: File.file?(File.join(Dir.pwd, ".rails")),
        bundler: true
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

        parser.on("-h", "--help", "Prints this help") do
          puts parser
          exit
        end

        parser.parse!(argv)

        runner = Runner.new

        trap("SIGINT") { exit! }

        runner.start(options: options)
      end
    end
  end
end
