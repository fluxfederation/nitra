require_relative '../../spec_helper.rb'
require_relative '../../../lib/nitra/workers/cucumber'

require 'cucumber'
require_relative '../../../lib/nitra/ext/cucumber'

describe Nitra::Workers::Cucumber do
  describe '#parse_results' do
    describe 'when no scenarios were run' do
      it 'correctly parses the output' do
        result_string = '0 scenarios'
        io = StringIO.new(result_string)
        results = Nitra::Workers::Cucumber.new(1, 1, Nitra::Configuration.new).parse_results(io)

        results.must_equal({ "test_count" => 0, "failure_count" => 0, "failure" => false })
      end
    end

    describe 'when all scenarios were successful' do
      it 'correctly parses the output' do
        result_string = '2 scenarios (2 passed)'
        io = StringIO.new(result_string)
        results = Nitra::Workers::Cucumber.new(1, 1, Nitra::Configuration.new).parse_results(io)

        results.must_equal({ "test_count" => 2, "failure_count" => 0, "failure" => false })
      end
    end

    describe 'when one scenario flakes' do
      it 'correctly parses the output' do
        result_string = '2 scenarios (1 flaky, 1 passed)'
        io = StringIO.new(result_string)
        results = Nitra::Workers::Cucumber.new(1, 1, Nitra::Configuration.new).parse_results(io)

        results.must_equal({ "test_count" => 2, "failure_count" => 0, "failure" => false })
      end
    end

    describe 'when all scenarios fail' do
      it 'correctly parses the output' do
        result_string = '1 scenario (1 failed)'
        io = StringIO.new(result_string)
        results = Nitra::Workers::Cucumber.new(1, 1, Nitra::Configuration.new).parse_results(io)

        results.must_equal({ "test_count" => 1, "failure_count" => 1, "failure" => false })
      end
    end

    describe 'when the output is a mix of results' do
      it 'correctly parses the output' do
        result_string = '3 scenario (1 failed, 1 flaky, 1 passed)'
        io = StringIO.new(result_string)
        results = Nitra::Workers::Cucumber.new(1, 1, Nitra::Configuration.new).parse_results(io)

        results.must_equal({ "test_count" => 3, "failure_count" => 1, "failure" => false })
      end
    end
  end
end
