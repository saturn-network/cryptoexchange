require 'spec_helper'

RSpec.describe 'Coinhub integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:eth_usd_pair) { Cryptoexchange::Models::MarketPair.new(base: 'ETH', target: 'USD', market: 'coinhub', inst_id: 49) }

  it 'fetch pairs' do
    pairs = client.pairs('coinhub')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'coinhub'
  end

  it 'fetch ticker' do
    ticker = client.ticker(eth_usd_pair)

    expect(ticker.base).to eq 'ETH'
    expect(ticker.target).to eq 'USD'
    expect(ticker.market).to eq 'coinhub'
    expect(ticker.last).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.change).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
  end
  
  it 'fetch order book' do
    order_book = client.order_book(eth_usd_pair)

    expect(order_book.base).to eq 'ETH'
    expect(order_book.target).to eq 'USD'
    expect(order_book.market).to eq 'coinhub'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 10
    expect(order_book.bids.count).to be > 10
    expect(order_book.timestamp).to be nil
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(eth_usd_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.base).to eq 'ETH'
    expect(trade.target).to eq 'USD'
    expect(trade.market).to eq 'coinhub'
    expect(trade.trade_id).to_not be_nil
    expect(['buy', 'sell']).to include trade.type
    expect(trade.price).to_not be_nil
    expect(trade.amount).to_not be_nil
    expect(trade.timestamp).to be_a Numeric
    expect(2000..Date.today.year).to include(Time.at(trade.timestamp).year)
    expect(trade.payload).to_not be nil
  end
end
