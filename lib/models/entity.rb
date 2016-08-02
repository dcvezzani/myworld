module AwesomeCompany
  module Model
    module Entity

      def self.included(base)
        base.extend(ClassMethods)

        base.instance_eval do
          attribute :name, String
        end
      end

      module ClassMethods
      end
    end
  end
end


