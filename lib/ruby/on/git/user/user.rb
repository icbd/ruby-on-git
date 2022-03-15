# frozen_string_literal: true

module Ruby
  module On
    module Git
      class User
        attr_reader :name, :email, :date

        def initialize(name, email, date)
          @name = name
          @email = email
          @date = date
        end

        def to_s
          "#{name} <#{email}> #{date.strftime("%s %z")}"
        end
      end
    end
  end
end
