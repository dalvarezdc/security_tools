#!/bin/bash
https://jup.ag/

CHROME_PROFILE="Profile 2"
BROWSER_EXEC="google-chrome"

FIREFOX_WEBSITES=(
  "https://dexscreener.com/?rankBy=trendingScoreH1&order=desc&chainIds=solana&minLiq=10000&minMarketCap=65000&maxMarketCap=11000000&min1HTxns=200&min1HVol=8000"
  "https://rugcheck.xyz/"
  "https://gmgn.ai/?chain=sol"
  "https://solanabox.tools/"
  "https://www.solsniffer.com/"
  "https://t.me/TrenchyBot"
)
CHROME_WEBSITES=(
  "https://www.drift.trade/"
  "https://photon-sol.tinyastro.io/en/discover"
  "https://www.sniper.xyz/"
)
CONSULTING_WEBSITES=(
  "https://x.com/nftimm_sol/status/1738497599873880575"
)

firefox "${FIREFOX_WEBSITES[@]}"
"$BROWSER_EXEC" --new-window --profile-directory="$CHROME_PROFILE" "${CHROME_WEBSITES[@]}" &
echo "$CONSULTING_WEBSITES"
