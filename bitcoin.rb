require 'net/http'       # Loads the standard library to perform HTTP requests
require 'json'           # Loads the standard library to parse JSON strings into Ruby hashes

# Defines a class responsible for fetching and displaying the Bitcoin price
class BitcoinPriceFetcher
  # CoinGecko API URL for fetching the current Bitcoin price in USD
  COINGECKO_URL = 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd'

  # Public method that gets and displays the Bitcoin price
  def actual_price
    price = fetch_price                          # Calls a private method to get the price
    formatted_price = '%.2f' % price             # Formats the number to two decimal places (e.g., 107960.33)
    formatted_price = formatted_price.gsub('.', ',').reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
    # Replaces dot with comma for decimals, adds thousand separators using reverse+gsub+reverse

    puts "[#{timestamp}] Current Bitcoin price: USD $#{formatted_price}"  # Displays the formatted price with timestamp
    log_price(price)                            # Logs the price to a CSV file
  end

  private

  # Makes the HTTP request and parses the price from the JSON response
  def fetch_price
    uri = URI(COINGECKO_URL)                    # Parses the API URL
    http = Net::HTTP.new(uri.host, uri.port)   # Initializes the HTTP connection
    http.use_ssl = true                         # Enables HTTPS
    http.read_timeout = 5                       # Timeout for reading the response
    http.open_timeout = 5                       # Timeout for opening the connection

    response = http.get(uri.request_uri)        # Performs the GET request
    data = JSON.parse(response.body)            # Parses the JSON into a Ruby hash
    data['bitcoin']['usd']                      # Returns the price value
  end

  # Returns current time formatted as HH:MM:SS
  def timestamp
    Time.now.strftime("%H:%M:%S")
  end

  # Appends the timestamp and price to a CSV log file
  def log_price(price)
    File.open("log.csv", "a") do |file|
      file.puts "#{Time.now},#{price}"
    end
  end
end

# ======= Main Execution Loop =======

# Gets interval from command-line arguments, defaults to 10 seconds
interval = ARGV[0]&.to_i
interval = 10 if interval.nil? || interval <= 0

puts "Starting Bitcoin price fetcher. Refreshing every #{interval} seconds..."
puts "Press Ctrl + C to stop.\n\n"

# Infinite loop that fetches and displays the price at defined intervals
loop do
  begin
    BitcoinPriceFetcher.new.actual_price
  rescue StandardError => e
    puts "[#{Time.now.strftime('%H:%M:%S')}] Error: #{e.class} - #{e.message}"
  end
  sleep interval
end
