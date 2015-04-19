require "active_model_serializers/namespaces/version"

module ActiveModelSerializers
  module Namespaces
    class NamespacedSerializerFinder

      def initialize unscoped_name
        @unscoped_name = unscoped_name
      end

      def new *args
        found_class = nil

        options = (args.last.kind_of?(Hash) ? args.last : {})
        prefix = options[:serialization_namespace]

        namespaced_name = [prefix, @unscoped_name].compact.join("::")

        if namespaced_name.respond_to?(:safe_constantize)
          found_class = namespaced_name.safe_constantize
        else
          begin
            found_class = namespaced_name.constantize
          rescue NameError => e
            raise unless e.message =~ /uninitialized constant/
          end
        end

        found_class ||= ActiveModelSerializers::Namespaces::DefaultSerializer
        found_class.new *args
      end

    end


    class DefaultSerializer < ActiveModel::DefaultSerializer

      def to_json *args
        serializable_hash.to_json *args
      end

      def to_xml *args
        serializable_hash.to_xml *args
      end

    end
  end
end


module ActiveModel
  module SerializerSupport
    extend ActiveSupport::Concern

    module ClassMethods #:nodoc:

      def active_model_serializer
        @namespaced_serializer_finder ||=
          ActiveModelSerializers::Namespaces::NamespacedSerializerFinder.new("#{self.name}Serializer")
      end

    end
  end
end
