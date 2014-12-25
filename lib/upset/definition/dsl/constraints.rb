# encoding: utf-8

module Upset
  module Definition
    module Dsl
      module Constraints
        def a(kind)
          KindConstraint.new(kind)
        end
        alias :an :a

        def matching(pattern)
          RegexpConstraint.new(pattern)
        end

        def a_file
          FileConstraint.new
        end

        def between(lower, upper)
          RangeConstraint.new(lower, upper)
        end

        def above(lower)
          between(lower, nil)
        end

        def below(upper)
          between(nil, upper)
        end

        def a_positive_integer
          both an(Integer), above(1)
        end

        def all(constraint)
          MemberConstraint.new(constraint)
        end

        def either(*constraints)
          DisjunctiveConstraint.new(*constraints)
        end

        def both(*constraints)
          ConjunctiveConstraint.new(*constraints)
        end
      end
    end
  end
end
