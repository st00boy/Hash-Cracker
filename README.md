# 🔓 Bash Hash Cracker

A simple, lightweight Bash-based hash cracker that supports multiple hash types, auto-detects hash format based on length, and cracks hashes using a wordlist. Includes clipboard support and time tracking.

📘 Educational Use Only
This tool is developed for learning, ethical hacking practice, and cybersecurity education.
Misuse may violate laws or terms of service. Always act responsibly and legally.



## 🚀 Features

- 🔍 Automatically detects common hash types (MD5, SHA1, SHA256, etc.)
- 📋 Copies cracked password to the clipboard (requires `xclip` or `pbcopy`)
- 🕒 Shows time taken and number of attempts
- 📂 Includes a sample wordlist 
- 💡 Optionally specify hash type manually using `--type`
- 🛠 No external cracking tools required – uses `openssl`

## 🧪 Supported Hash Types

| Hash Type | Length |
|-----------|--------|
| MD5       | 32     |
| SHA1      | 40     |
| SHA224    | 56     |
| SHA256    | 64     |
| SHA384    | 96     |
| SHA512    | 128    |

## 📦 Requirements

- `bash`
- `openssl`
- `xclip` (Linux) or `pbcopy` (macOS) for clipboard copy (optional)

## 📄 Usage

```bash
./cracker.sh [--type <hash-type>] <hash> <wordlist.txt>


🔁 Examples
Auto-detect hash type:
 ./cracker.sh 5f4dcc3b5aa765d61d8327deb882cf99 rockyou.txt

Force specific hash type:
 ./cracker.sh --type sha256 d2d2d2d2... mylist.txt


✅ Output Example:

[*] Trying sha256 on 100000 words...
[>] Attempt 512: password123
✅ Password found: password123 (sha256)
✔ Copied to clipboard!
⏱ Cracked in 12 seconds after 512 attempts.

⚠ Notes
This script performs a brute-force search using a wordlist. It’s best for weak hashes and testing purposes.

If the hash isn’t found, try using a bigger wordlist or the correct algorithm.


Created with ❤️ by st00boy


📜 License
MIT License
