set -o errexit

swift build -c release
echo "[AUTHOR]

@Samasaur1 on GitHub" > author.inc
help2man -i author.inc -o server.1 -N .build/release/server
rm author.inc
