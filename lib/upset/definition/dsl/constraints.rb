# encoding: utf-8

module Upset
  module Definition
    module Dsl
      module Constraints
        def kind(kind)
          KindConstraint.new(kind)
        end

        def matching(pattern)
          RegexpConstraint.new(pattern)
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
