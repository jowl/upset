# encoding: utf-8

module Upset
  module Definition
    module Dsl
      module Constraints
        def is_a(kind)
          KindConstraint.new(kind)
        end

        def matches(pattern)
          RegexpConstraint.new(pattern)
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
