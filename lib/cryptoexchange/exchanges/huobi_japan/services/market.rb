module Cryptoexchange::Exchanges
  module HuobiJapan
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          name = "#{market_pair.base}#{market_pair.target}".downcase
          base = Cryptoexchange::Exchanges::HuobiJapan::Market::API_URL

          "#{base}/market/detail/merged?symbol=#{name}"
        end

        def adapt(output, market_pair)
          market = output['tick']

          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = HuobiJapan::Market::NAME
          ticker.last      = NumericHelper.to_d(market['close'])
          ticker.bid       = NumericHelper.to_d(market['bid'][0]) if market['bid']
          ticker.ask       = NumericHelper.to_d(market['ask'][0]) if market['ask']
          ticker.high      = NumericHelper.to_d(market['high'])
          ticker.low       = NumericHelper.to_d(market['low'])
          ticker.volume    = NumericHelper.to_d(market['amount']) ? NumericHelper.to_d(market['amount']) : 0
          ticker.timestamp = nil
          ticker.payload   = market
          ticker
        end
      end
    end
  end
end
