module SwitchPoint
  class Config
    def initialize
      self.auto_writable = false
    end

    def define_switch_point(name, config)
      assert_valid_config!(config)
      switch_points[name] = config
    end

    def auto_writable=(val)
      @auto_writable = val
    end

    def auto_writable?
      @auto_writable
    end

    def switch_points
      @switch_points ||= {}
    end

    def database_name(name, mode)
      config = switch_points[name][mode]
      if config.is_a?(Array)
        config.sample
      else
        config
      end
    end

    def model_name(name, mode)
      if switch_points[name][mode]
        "#{name}_#{mode}".camelize
      else
        nil
      end
    end

    def fetch(name)
      switch_points.fetch(name)
    end

    def keys
      switch_points.keys
    end

    private

    def assert_valid_config!(config)
      unless config.has_key?(:readonly) || config.has_key?(:writable)
        raise ArgumentError.new(':readonly or :writable must be specified')
      end
      if config.has_key?(:readonly)
        unless config[:readonly].is_a?(Symbol) || config[:readonly].is_a?(Array)
          raise TypeError.new(":readonly's value must be Symbol or Array")
        end

        if config[:readonly].is_a?(Array)
          config[:readonly].each do |readonly_value|
            unless readonly_value.is_a?(Symbol)
              raise TypeError.new(":readonly array's value must be Symbol")
            end
          end
        end
      end
      if config.has_key?(:writable)
        unless config[:writable].is_a?(Symbol)
          raise TypeError.new(":writable's value must be Symbol")
        end
      end
      nil
    end
  end
end
