module Guard
  class RackUnit
    class Command < String
      def initialize(paths)
        # TODO - this is crazy
        super(paths.unshift("test").unshift("raco").join(' '))
      end
    end
  end
end
