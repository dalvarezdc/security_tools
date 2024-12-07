# NOT WORKING YET
from dexscreener import DexscreenerClient

# Initialize the client
client = DexscreenerClient()

# Fetch pairs associated with a specific token address
# Replace 'YOUR_TOKEN_ADDRESS' with the actual token address you're interested in
pairs = client.get_token_pairs('YOUR_TOKEN_ADDRESS')

# Define your filtering criteria
min_liquidity = 10000
min_market_cap = 65000
max_market_cap = 11000000
min_1h_txns = 200
min_1h_vol = 8000

# Filter pairs based on the criteria
filtered_pairs = [
    pair for pair in pairs
    if (
        pair.liquidity.usd >= min_liquidity and
        min_market_cap <= pair.fdv <= max_market_cap and
        pair.volume.h1 >= min_1h_vol and
        pair.txns.h1 >= min_1h_txns
    )
]

# Sort the filtered pairs by trending score in descending order
sorted_pairs = sorted(filtered_pairs, key=lambda x: x.trending_score.h1, reverse=True)

# Display the results
for pair in sorted_pairs:
    print(f"Pair Address: {pair.pair_address}")
    print(f"Base Token: {pair.base_token.name} ({pair.base_token.symbol})")
    print(f"Quote Token: {pair.quote_token.name} ({pair.quote_token.symbol})")
    print(f"Price: ${pair.price_usd:.2f}")
    print(f"Liquidity: ${pair.liquidity.usd:,}")
    print(f"FDV: ${pair.fdv:,}")
    print(f"1H Volume: ${pair.volume.h1:,}")
    print(f"1H Transactions: {pair.txns.h1:,}")
    print(f"Trending Score (1H): {pair.trending_score.h1}")
    print("-" * 40)
