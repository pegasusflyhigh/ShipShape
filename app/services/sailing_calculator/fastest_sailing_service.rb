# frozen_string_literal: true

# This class extends the BaseService to find the fastest sailing options between
# an origin and destination port.
#
# The algorithm works as follows:
#
# 1. For each port in the queue, calculate the duration of sailing options from that port.
# 2. Calculate the duration by subtracting departure_date from arrival_date.
# 3. Incorporate any backtraced costs into the duration.
# 4. Calculate land time that the fright may spend between two sailings.
# 5. Update costs and parents if a shorter path is found.

module SailingCalculator
  class FastestSailingService < BaseService

    private

    def process_sailing_options(options, current_port)
      options.each do |option|
        neighbor_port = option.destination_port
        total_cost = calculate_duration(option, current_port)
        sailing_rate = option.sailing_rates.first # Fetching the first sailing rate for simplicity

        update_cost_and_parents(neighbor_port, current_port, option, sailing_rate, total_cost)
      end
    end

    def calculate_duration(option, current_port)
      duration = (option.arrival_date - option.departure_date).to_i

      backtraced_cost = cost_with_backtracing(current_port, option)

      return duration if backtraced_cost.blank?

      backtraced_cost + duration
    end

    def cost_with_backtracing(current_port, option)
      return unless parents.key?(current_port)

      backtraced_cost = 0
      starting_port = current_port
      starting_option = option

      loop do
        land_time = (starting_option.departure_date - parents[starting_port][:option].arrival_date).to_i

        backtraced_cost += costs[starting_port] + land_time
        starting_option = parents[starting_port][:option]

        if parents[starting_port].blank?
          backtraced_cost = 0
          break
        end

        starting_port = parents[starting_port][:port]

        break if starting_port == origin_port || starting_port == current_port
      end

      backtraced_cost
    end

    def sailing_options(port)
      SailingOption.includes(sailing_rates: :currency).sailing_starting_from_origin_port(port)
    end

  end
end
