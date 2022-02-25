# frozen_string_literal: true

module Joi
  class Runner
    attr_reader :root_dir, :watchers

    def initialize(root_dir = Dir.pwd)
      @root_dir = Pathname.new(root_dir)
      @watchers = []
    end

    def start(options:, preset: Presets::Default)
      preset.call(self, options)
      preset.run_all(options)

      listener = Listen.to(
        root_dir.to_s,
        ignore: [%r{(public|node_modules|assets|vendor)/}]
      ) do |modified, added, removed|
        modified = convert_to_relative_paths(modified)
        added = convert_to_relative_paths(added)
        removed = convert_to_relative_paths(removed)

        watchers.each do |watcher|
          run_watcher(
            watcher,
            modified: modified,
            added: added,
            removed: removed
          )
        end
      end

      listener.start

      sleep
    end

    def run_watcher(watcher, modified:, added:, removed:)
      paths = []
      paths += modified if watcher[:on].include?(:modified)
      paths += added if watcher[:on].include?(:added)
      paths += removed if watcher[:on].include?(:removed)
      paths = paths.select do |path|
        watcher[:pattern].any? {|pattern| path.to_s.match?(pattern) }
      end

      return unless paths.any?

      watcher[:thread]&.kill
      watcher[:thread] = Thread.new { watcher[:command].call(paths) }
    end

    def watch(watcher)
      watchers << watcher
    end

    def convert_to_relative_paths(paths)
      paths.map {|file| Pathname.new(file).relative_path_from(root_dir) }
    end
  end
end
