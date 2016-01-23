require 'thread_safe'
module Coverband
  class MemoryCacheStore

    attr_accessor :store


    def self.files_cache
      @files_cache ||= ThreadSafe::Cache.new
    end

    def self.reset!
      files_cache.clear
    end

    def initialize(store)
      @store = store
    end

    def store_report files
      filtered_files = filter(files)
      store.store_report(filtered_files) if filtered_files.any?
    end

    private

    def files_cache
      self.class.files_cache
    end

    def filter(files)
      files.each_with_object(Hash.new) do |(file, lines), filtered_file_hash|
        line_cache = files_cache[file] ||= Set.new
        lines.reject! do |line|
          if line_cache.include? line
            true
          else
            line_cache << line
            false
          end
        end
        filtered_file_hash[file] = lines if lines.any?
      end
    end

  end
end