module CheckedAttributes
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def attr_checked(variable, &validation)
      define_method "#{variable}=" do |value|
        raise 'Invalid attribute' unless validation.call(value)
        instance_variable_set("@#{variable}", value)
      end
      define_method variable do
        instance_variable_get("@#{variable}")
      end
    end
  end
end


class Person
  include CheckedAttributes
  attr_checked :age do |v|
    v >= 18
  end
end
@bob = Person.new

@bob.age = 20
puts @bob.age == 20

@bob.age = 17