# frozen_string_literal: true

module Ruby
  module On
    module Git
      module Object
        class Base
          include Config

          def initialize
          end

          def hash_id
            @hash_id ||= Digest::SHA1.hexdigest(frame)
          end

          def type
            self.class.name.demodulize.downcase
          end

          def frame
            frame_data.force_encoding(Encoding::ASCII_8BIT)
            "#{type} #{frame_data.bytesize}\0#{frame_data}"
          end

          def frame_data
            raise Error, "Should be implemented"
          end

          def save
            compressed_data = Zlib::Deflate.deflate(frame, Zlib::BEST_SPEED)

            FileUtils.mkdir object_file_dir unless Dir.exist? object_file_dir
            # TODO: large file may not be written all at once.
            IO.binwrite object_file_path, compressed_data
          end

          def object_file_dir
            File.join git_objects_dir, hash_id[0..1]
          end

          def object_file_path
            File.join object_file_dir, hash_id[2..]
          end
        end
      end
    end
  end
end
