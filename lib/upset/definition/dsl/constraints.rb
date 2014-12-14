# encoding: utf-8

module Upset
  module Definition
    module Dsl
      module Constraints
        def is_a(kind)
          KindConstraint.new(kind)
        end
        alias :is_an :is_a

        def matches(pattern)
          RegexpConstraint.new(pattern)
        end

        def is_a_file
          FileConstraint.new
        end

        def is_between(lower, upper)
          RangeConstraint.new(lower, upper)
        end

        def is_above(lower)
          is_between(lower, nil)
        end

        def is_below(upper)
          is_between(nil, upper)
        end

        def each_member(constraint)
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
