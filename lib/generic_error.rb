# frozen_string_literal: true

# This class can be used for returning a single error message
# when there is no error object (from ActiveRecord object) present.
#
# Example: passing a symbol
#
# > ServiceResponse.error(:some_error_message)
#
# Uses the error key to look up the translation from the following entry in en.yml:
# 'activemodel.errors.models.generic_error.attributes.base.your_key'
#
# Behaves like a model with errors.
#
# Example: passing a string
#
# > raise GenericError.new('something went wrong')
#
# Behaves like an exception.
class GenericError < StandardError

  include ActiveModel::Validations

  def initialize(error, options = {})
    if error.is_a?(Symbol)
      errors.add(:base, error, **options)
    else
      super(error)
    end
  end

end
