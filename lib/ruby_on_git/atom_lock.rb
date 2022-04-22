# frozen_string_literal: true

require_relative "./helpers"

module RubyOnGit
  # Avoid competition between multiple processes
  # operating at the same time.
  class AtomLock
    include Helpers

    # create file if it not exist
    LOCK_FILE_FLAG = File::RDWR | File::CREAT | File::EXCL

    StaleLock = Class.new(StandardError)

    def initialize(target_file_path)
      @target_file_path = target_file_path
      @lock_file_path = File.join(git_dir, ".lock")
      @lock = nil
    end

    def self.with_lock(target)
      atom_lock = new(target)
      atom_lock.hold_for_update

      atom_lock.write(yield)
      atom_lock.commit
    end

    # return @lock or nil
    def hold_for_update
      @lock = File.open(@lock_file_path, LOCK_FILE_FLAG) if @lock.nil?
    rescue Errno::EEXIST => _e
      raise StaleLock, "Could not acquire lock on file: #{@lock_file_path}"
    end

    def write(content)
      raise_if_stale

      @lock.write content
    end

    def commit
      raise_if_stale

      @lock.close
      File.rename(@lock_file_path, @target_file_path)
      @lock = nil
    end

    private

    def raise_if_stale
      raise StaleLock, "Not holding lock on file: #{@lock_file_path}" if @lock.nil?
    end
  end
end
