module AwesomeCompany
  module Model
    module Basic

      def self.included(base)
        base.include Virtus.model
        base.include ActiveModel::Serialization
        base.include ActiveModel::Serializers::JSON
        base.include ActiveModel::Serializers::Xml
        # base.include ActiveModel::Validations
        
        base.extend(ClassMethods)

        base.instance_eval do
          attribute :redis, Object
        end
      end

      def to_json
        attrs = self.attributes.select{|k,v| k != :redis}
        attrs.to_json
      end

      def redis_key; self.class.redis_key; end

      def entity_names
        redis.hkeys(redis_key)
      end

      def entity_name(name)
        redis.hget(redis_key, name)
      end
    
      def load_basic_accessors(*args)
        self.class.send(:define_method, "#{self.redis_key}_name".to_sym){ |name| entity_name(name) }
        self.class.send(:define_method, "#{self.redis_key}_names".to_sym){ entity_names }
      end
    
      module ClassMethods
        def load(attrs)
          redis = attrs[:redis]
          p = self.new(attrs.merge({redis: redis}))
          
          @load_callbacks.each do |cb|
            p.send(cb, attrs)
          end

          p
        end

        def resource(*name)
          return @resource_value unless @resource_value.nil?
          @resource_value = (name.first) ? name.first : self.name.match(/([^:]*)$/)[1].downcase
        end

        alias_method :redis_key, :resource
        
        def after_load(*callbacks)
          @load_callbacks = [:load_basic_accessors] if @load_callbacks.nil?
          @load_callbacks.concat(callbacks)
        end

        def from_json(json)
          attrs = JSON::load(json)
          redis = (attrs['redis'] or $redis)
          load(HashWithIndifferentAccess.new(attrs.merge({redis: redis})))
        end
        
      end
    end
  end
end


