# frozen_string_literal: true

RSpec.shared_context 'when sailing data exists' do
  let_it_be(:origin_port) { create(:port, code: 'CNSHA', name: 'Shanghai') }
  let_it_be(:destination_port) { create(:port, code: 'NLRTM', name: 'Rotterdam') }
  let_it_be(:barcelona_port) { create(:port, code: 'ESBCN', name: 'Barcelona') }

  # CNSHA -> NLRTM
  let_it_be(:shanghai_sailing_rate) { create(:sailing_rate, :with_japanese_yen_currency) }
  let_it_be(:min_direct_sailing_option) do
    create(:sailing_option, origin_port: origin_port, destination_port: destination_port,
                            sailing_rates: [shanghai_sailing_rate])
  end
  let_it_be(:min_sailing_rate) { min_direct_sailing_option.sailing_rates.first }
  let_it_be(:lowest_exchange_rate) do
    create(:exchange_rate, exchange_date: min_direct_sailing_option.departure_date,
                           currency: min_sailing_rate.currency, rate: 1.2)
  end

  # CNSHA -> NLRTM
  let_it_be(:another_direct_sailing_option) do
    create(:sailing_option, :with_sailing_rates, origin_port:, destination_port:)
  end
  let_it_be(:another_sailing_rate) { another_direct_sailing_option.sailing_rates.first }
  let_it_be(:another_exchange_rate) do
    create(:exchange_rate, exchange_date: another_direct_sailing_option.departure_date,
                           currency: another_sailing_rate.currency, rate: 0.3)
  end

  # CNSHA -> ESBCN
  let_it_be(:another_sailing_option_from_shanghai) do
    create(:sailing_option, origin_port: origin_port, destination_port: barcelona_port,
                            sailing_rates: [shanghai_sailing_rate])
  end
  let_it_be(:japanese_yen_exchange_rate) do
    create(:exchange_rate, exchange_date: another_sailing_option_from_shanghai.departure_date,
                           currency: shanghai_sailing_rate.currency, rate: 2)
  end

  # ESBCN -> NLRTM
  let_it_be(:barcelona_sailing_rate) { create(:sailing_rate, :with_us_dollars_currency) }
  let_it_be(:sailing_option_from_barcelona) do
    create(:sailing_option, origin_port: barcelona_port, destination_port: destination_port,
                            sailing_rates: [barcelona_sailing_rate])
  end
  let_it_be(:euro_exchange_rate) do
    create(:exchange_rate, exchange_date: sailing_option_from_barcelona.departure_date,
                           currency: barcelona_sailing_rate.currency, rate: 3)
  end
end
