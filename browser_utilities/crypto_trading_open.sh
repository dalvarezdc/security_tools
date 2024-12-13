#!/bin/bash

CHROME_PROFILE="Profile 2"
BROWSER_EXEC="google-chrome"

# Dexscreener parameters
DEX_TRENDING_SCORE="pairAge"  # "trendingScoreH1"
DEX_ORDER="asc"  # "desc"
DEX_CHAIN_ID="solana"
DEX_MIN_LIQ=20000
DEX_MIN_MARKET_CAP=65000
DEX_MAX_MARKET_CAP=11000000
DEX_MIN_1H_TXNS=100
DEX_MIN_1H_VOL=8000

# Construct the Dexscreener URL
DEXSCREENER_URL="https://dexscreener.com/?rankBy=${DEX_TRENDING_SCORE}&order=${DEX_ORDER}&chainIds=${DEX_CHAIN_ID}&minLiq=${DEX_MIN_LIQ}&minMarketCap=${DEX_MIN_MARKET_CAP}&maxMarketCap=${DEX_MAX_MARKET_CAP}&min1HTxns=${DEX_MIN_1H_TXNS}&min1HVol=${DEX_MIN_1H_VOL}"

FIREFOX_WEBSITES=(
  "$DEXSCREENER_URL"
  "https://gmgn.ai/discover?chain=sol&tab=all"
)
CHROME_WEBSITES=(
  "https://photon-sol.tinyastro.io/en/discover"
  "https://jup.ag/"
  "https://rugcheck.xyz/"
  "https://www.solsniffer.com/"
  "https://app.tweetscout.io/"
  "https://app.cielo.finance/feed"
)

# Declare an associative array
declare -A my_array=(
    [orangie_twitter]="https://x.com/nftimm_sol/status/1738497599873880575"
    [orangie_dicord_group_expensive]="https://www.potionalpha.com/"
    [orangie_wallet_tracker]="https://app.cielo.finance/feed"
    [trenchy_bot]="https://t.me/TrenchyBot"
    [solana_tools]="https://solanabox.tools/"
    [perps_trading]="https://www.drift.trade/"
    [sniper_xyz]="https://www.sniper.xyz/"
    [solana_trading_bot_1]="https://www.solanatracker.io/solana-trading-bot"
    [twitter_check]="https://app.tweetscout.io/"
    [interesiting_multiple_api_documentations]="https://docs.bitquery.io/docs/examples/Solana/Pump-Fun-API/"
)

# Iterate over the array and print key-value pairs
for key in "${!my_array[@]}"; do
    echo "Key: $key, Value: ${my_array[$key]}"
done


firefox "${FIREFOX_WEBSITES[@]}" &
"$BROWSER_EXEC" --new-window --profile-directory="$CHROME_PROFILE" "${CHROME_WEBSITES[@]}" &
discord &
wait
