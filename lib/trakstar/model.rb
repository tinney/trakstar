module Trakstar
  module Models
    class Base
      attr_accessor :api_id, :sync

      def get(attr)
        sync.call if instance_variable_get("@#{attr}").nil?
        instance_variable_get("@#{attr}")
      end

      def set(attr, val)
        instance_variable_set("@#{attr}", val)
      end

      class << self
        private

        # Some methods come from a different sync process
        # this allows us to load all the candidates in on a single call
        # and sync the other data as needed.

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
    end
  end
end
