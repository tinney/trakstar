module Trakstar
  module Models
    class Base
      attr_accessor :api_id, :sync

      def get(attr)
        sync.call unless loaded?
        instance_variable_get("@#{attr}")
      end

      def set(attr, val)
        instance_variable_set("@#{attr}", val)
      end

      def loaded!
        @loaded = true
      end

      def loaded?
        @loaded
      end

      class << self
        private

        def synced_attr_accessor(*attr_names)
          attr_names.each do |name|
            define_method name do
              get(name)
            end

            define_method "#{name}=" do |val|
              set(name, val)
            end
          end
        end
      end

      private

      attr_accessor :loaded
    end
  end
end
