# frozen_string_literal: true

module SailingCalculator
  class CheapestDirectSailingService < BaseService

    private

    def sailing_options(port)
      SailingOption.includes(sailing_rates: :currency).direct_between(port, destination_port)
    end

    def success_response(paths)
      result = format_sailing_options(paths)
      ServiceResponse.success(result.first) # Direct sailing can have only one result
    end

  end
end
