# frozen_string_literal: true

class ServiceResponse
  attr_reader :result, :errors

  def initialize(status:, result: nil, errors: nil)
    @status = status
    @result = result
    @errors = errors
  end

  def success?
    @status == :success
  end

  def failure?
    @status == :error
  end

  def self.success(result)
    new(status: :success, result: result)
  end

  def self.error(errors_or_error_symbol, options = {})
    # Use the given error object or build a GenericError object which only contains one error message
    errors = if errors_or_error_symbol.is_a?(Symbol)
               GenericError.new(errors_or_error_symbol,
                                options).errors
             else
               errors_or_error_symbol
             end

    new(status: :error, errors: errors)
  end
end
