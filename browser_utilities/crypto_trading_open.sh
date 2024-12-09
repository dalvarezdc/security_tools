#!/bin/bash

CHROME_PROFILE="Profile 2"
BROWSER_EXEC="google-chrome"

FIREFOX_WEBSITES=(
  "https://dexscreener.com/?rankBy=trendingScoreH1&order=desc&chainIds=solana&minLiq=10000&minMarketCap=65000&maxMarketCap=11000000&min1HTxns=200&min1HVol=8000"
  "https://gmgn.ai/?chain=sol"
  "https://app.cielo.finance/feed"
)
CHROME_WEBSITES=(
  "https://photon-sol.tinyastro.io/en/discover"
  "https://jup.ag/"
  "https://rugcheck.xyz/"
  "https://www.solsniffer.com/"
  "https://app.tweetscout.io/"
)

# Declare an associative array
declare -A my_array=(
    [orangie_twitter]="https://x.com/nftimm_sol/status/1738497599873880575"
    [orangie_dicord_bot_expensive]="https://www.potionalpha.com/"
    [orangie_wallet_tracker]="https://app.cielo.finance/feed"
    [trenchy_bot]="https://t.me/TrenchyBot"
    [solana_tools]="https://solanabox.tools/"
    [perps_trading]="https://www.drift.trade/"
    [sniper_xyz]="https://www.sniper.xyz/"
    [solana_trading_bot_1]="https://www.solanatracker.io/solana-trading-bot"
    [twitter_check]="https://app.tweetscout.io/"
)

# Iterate over the array and print key-value pairs
for key in "${!my_array[@]}"; do
    echo "Key: $key, Value: ${my_array[$key]}"
done


firefox "${FIREFOX_WEBSITES[@]}" &
"$BROWSER_EXEC" --new-window --profile-directory="$CHROME_PROFILE" "${CHROME_WEBSITES[@]}" &
discord &
wait
