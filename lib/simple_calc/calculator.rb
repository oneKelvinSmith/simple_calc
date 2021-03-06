require 'simple_calc/expression'
require 'simple_calc/errors'

module SimpleCalc
  class Calculator
    def read_expressions(file)
      File.readlines(file).map do |line|
        new_expression(formula: line.strip)
      end
    end

    def new_expression(args)
      source = args[:source] || SimpleCalc::Expression.public_method(:new)
      formula = args[:formula]
      expression = source.call(formula: formula)
      return expression if expression.validate!
    end

    def calculate(expressions)
      expressions.map(&:evaluate)
    end
  end
end
