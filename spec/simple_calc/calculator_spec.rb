require 'simple_calc/calculator'
require 'simple_calc/expression'
require 'simple_calc/errors'

RSpec.describe SimpleCalc::Calculator do
  let(:expression)   { double('expression') }
  let(:calculator)   { SimpleCalc::Calculator.new }

  describe '#new_expression' do
    let(:source) { -> (_) { expression } }
    let(:syntax_error) { SimpleCalc::SyntaxError }

    before(:example) do
      allow(expression).to receive(:validate!).and_return true
    end

    it 'return a new expression for a given formula' do
      allow(SimpleCalc::Expression).to receive(:new).and_return(expression)

      expect(calculator.new_expression(formula: 'formula')).to be expression
    end

    it 'uses the expression factory provided' do
      new_expression = calculator.new_expression(source: source)
      expect(new_expression).to be expression
    end

    it 'send the expression source the formula' do
      source = spy('source')

      calculator.new_expression(formula: 'formula', source: source)

      expect(source).to have_received(:call).with(formula: 'formula')
    end

    it 'raises a syntax error when an expression is invalid' do
      allow(expression).to receive(:validate!).and_raise syntax_error

      expect do
        calculator.new_expression(formula: 'invalid', source: source)
      end.to raise_error syntax_error
    end
  end

  describe '#read_expressions' do
    let(:expressions)  { [expression, expression] }

    it 'parses an input file into expressions' do
      allow(calculator).to receive(:new_expression).and_return(expression)

      new_expressions = calculator.read_expressions('spec/data/expressions.txt')

      expect(new_expressions).to eq expressions
    end

    it 'does not create expressions for an empty file' do
      expect(calculator).not_to receive(:new_expression)

      calculator.read_expressions('spec/data/empty_file.txt')
    end
  end

  describe '#calculate' do
    let(:result) { double 'result' }

    it 'collects the results of expression evaluations' do
      allow(expression).to receive(:evaluate).and_return result

      expect(calculator.calculate([expression])).to eq [result]
    end
  end
end
