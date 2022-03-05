# frozen_string_literal: true

module Ruby
  module On
    module Git
      module Object
        class Base
          include Config
          attr_reader :hash_id

          def type
            self.class.name.demodulize.downcase
          end

          def frame
            raise Error, "Should be implemented"
          end

          def save
            @hash_id = Digest::SHA1.hexdigest(frame)
            data = Zlib::Deflate.deflate(frame, Zlib::BEST_SPEED)

            FileUtils.mkdir object_file_dir unless Dir.exist? object_file_dir
            # TODO: large file may not be written all at once.
            IO.write object_file_path, data
          end

          def object_file_dir
            check_hash_id!
            File.join git_objects_dir, hash_id[0..1]
          end

          def object_file_path
            File.join object_file_dir, hash_id[2..]
          end

          private

          def check_hash_id!
            raise GitObjectError, "@hash_id does not exist yet" if @hash_id.nil?
          end
        end
      end
    end
  end
end
