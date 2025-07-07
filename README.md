# Monitor_Bitcoin

# Bitcoin Price Fetcher (Ruby)

A simple Ruby script that fetches the current price of Bitcoin (BTC) in USD from the CoinGecko API and displays it in the terminal. Prices are formatted in Brazilian style (e.g., `107.960,33`) and logged to a CSV file for historical tracking.

## 🧰 Features

- Fetches live Bitcoin price from CoinGecko
- Displays the price every N seconds
- Saves historical data in `log.csv`
- Gracefully handles API/network errors
- Price is formatted as: `USD $107.960,33`

## 📦 Requirements

- Ruby 3.x
- Internet connection
