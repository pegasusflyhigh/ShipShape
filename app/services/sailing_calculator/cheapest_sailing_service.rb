# frozen_string_literal: true

module SailingCalculator
  class CheapestSailingService < BaseService

    private

    def sailing_options(port)
      SailingOption.includes(sailing_rates: :currency).sailing_starting_from_origin_port(port)
    end

  end
end
