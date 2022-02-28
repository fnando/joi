# frozen_string_literal: true

module Joi
  module Presets
    class Default
      attr_reader :options, :runner

      def initialize(runner, options)
        @runner = runner
        @options = options
      end

      def run_all
        if options[:rails]
          run_rails_test(options, [])
        else
          run_rake_test(options, [])
        end
      end

      def register
        run = lambda do |paths|
          system("clear")

          if options[:rails]
            run_rails_test(options, paths)
          else
            run_rake_test(options, paths)
          end
        end

        runner.watch(
          on: %i[removed],
          pattern: [/\.rb$/],
          command: lambda do |_paths|
            run.call([])
          end
        )

        runner.watch(
          on: %i[modified added],
          pattern: [
            %r{^(app|lib|test|config)/.+\.rb$},
            %r{^test/(test_helper|application_system_test_case|support/.+)\.rb$}
          ],
          command: lambda do |paths|
            test_paths = paths.filter_map do |path|
              path = path.to_s.gsub(%r{^(app|lib)/}, "test/")
              path = File.join(
                File.dirname(path),
                "#{File.basename(path.gsub(/(_test)?\.rb$/, ''))}_test.rb"
              )

              path = Pathname.new(path)

              path if path.file?
            end

            run.call(test_paths)
          end
        )
      end

      def run_rails_test(options, test_paths)
        command = []
        command += %w[bundle exec] if options[:bundler]
        command += %w[rails test]
        command += test_paths.map(&:to_s)

        run(nil, command)
      end

      def run_rake_test(options, test_paths)
        command = []
        command += %w[bundle exec] if options[:bundler]
        command += %w[rake test]

        if test_paths.any?
          test_paths.each do |test_path|
            run({"TEST" => test_path.to_s}, command)
          end
        else
          run(nil, command)
        end
      end

      def env_vars(env)
        return unless env

        env
          .map {|(key, value)| %[#{key}=#{Shellwords.shellescape(value.to_s)}] }
          .join(" ")
      end

      def run(env, command)
        puts [
          "\e[37m$",
          *command.map {|arg| Shellwords.shellescape(arg) },
          env_vars(env),
          "\e[0m"
        ].compact.join(" ")

        system(env || {}, *command)
      end
    end
  end
end
