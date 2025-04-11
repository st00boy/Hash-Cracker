#!/bin/bash

# Copy text to clipboard
copy_to_clipboard() {
    local text="$1"
    if command -v xclip &>/dev/null; then
        printf "%s" "$text" | xclip -selection clipboard
    elif command -v pbcopy &>/dev/null; then
        printf "%s" "$text" | pbcopy
    else
        echo "[!] Clipboard copy not supported (install xclip or pbcopy)."
    fi
}

# Identify hash type based on length
identify_hash() {
    local hash="$1"
    local length="${#hash}"
    case "$length" in
        32) echo "md5" ;;
        40) echo "sha1" ;;
        56) echo "sha224" ;;
        64) echo "sha256" ;;
        96) echo "sha384" ;;
        128) echo "sha512" ;;
        *) echo "unknown" ;;
    esac
}

# Attempt to crack the hash using multiple algorithms
try_all_hashes() {
    local hash="$1"
    local wordlist="$2"
    local start_time
    start_time=$(date +%s)
    local attempts=0
    local tried_any=0

    declare -A hash_lengths=(
        [md5]=32
        [sha1]=40
        [sha224]=56
        [sha256]=64
        [sha384]=96
        [sha512]=128
    )

    for algo in "${!hash_lengths[@]}"; do
        if [ "${#hash}" -eq "${hash_lengths[$algo]}" ]; then
            local total_words
            total_words=$(wc -l < "$wordlist")
            echo "[*] Trying $algo on $total_words words..."

            while IFS= read -r word; do
                word_clean=$(printf "%s" "$word" | tr -d '\r\n')
                computed=$(printf "%s" "$word_clean" | openssl dgst "-$algo" | awk '{print $2}')
                attempts=$((attempts + 1))

                echo -ne "\r[>] Attempt $attempts: $word_clean"

                if [ "$computed" = "$hash" ]; then
                    end_time=$(date +%s)
                    duration=$((end_time - start_time))
                    copy_to_clipboard "$word_clean"
                    echo -e "\n✅ Password found: $word_clean ($algo)"
                    echo "✔ Copied to clipboard!"
                    echo "⏱ Cracked in $duration seconds after $attempts attempts."
                    return
                fi
            done < "$wordlist"

            echo -e "\n❌ Password not found with $algo after $attempts attempts."
            tried_any=1
        fi
    done

    if [ "$tried_any" -eq 0 ]; then
        echo "[-] Unsupported or unknown hash length (${#hash})."
    fi
}

main() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 <hash> <wordlist.txt>"
        exit 1
    fi

    local hash="$1"
    local wordlist="$2"

    if [ ! -f "$wordlist" ]; then
        echo "[-] Wordlist not found: $wordlist"
        exit 1
    fi

    try_all_hashes "$hash" "$wordlist"
}

main "$@"

