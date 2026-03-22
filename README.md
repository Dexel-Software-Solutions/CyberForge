# 🔥 CyberForge

<div align="center">

```
  ██████╗██╗   ██╗██████╗ ███████╗██████╗ ███████╗ ██████╗ ██████╗  ██████╗ ███████╗
 ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝ ██╔════╝
 ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝█████╗  ██║   ██║██████╔╝██║  ███╗█████╗
 ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██╔══██╗██║   ██║██╔══╝
 ╚██████╗   ██║   ██████╔╝███████╗██║  ██║██║     ╚██████╔╝██║  ██║╚██████╔╝███████╗
  ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
```

**Advanced Software Engineering & Cyber Security Toolkit**

[![Version](https://img.shields.io/badge/version-2.0.0-red.svg)](https://github.com/demiyan-dissanayake/cyberforge)
[![Shell](https://img.shields.io/badge/shell-bash%205%2B-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL-blue.svg)]()
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)
[![Author](https://img.shields.io/badge/author-Demiyan%20Dissanayake-purple.svg)]()

> ⚠️ **FOR AUTHORIZED TESTING AND EDUCATIONAL USE ONLY.**  
> Unauthorized use against systems you do not own is **illegal**.

</div>

---

## 📋 Table of Contents

- [Features](#-features)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Modules](#-modules)
  - [Cyber Security](#-cyber-security-modules)
  - [Software Engineering](#-software-engineering-modules)
- [Examples](#-examples)
- [File Structure](#-file-structure)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

| Category | Highlights |
|---|---|
| 🔐 Cyber Security | Recon, Port Scanning, SSL/TLS Audit, DNS Enum, Web Audit, Vuln Scan |
| 🛠️ Software Engineering | System Info, Code Audit, SSH Audit, Docker Audit, Process Monitor |
| 🔑 Crypto Tools | Hash Cracker, Password Generator, Encode/Decode |
| 📊 Reporting | Full HTML-ready reports saved locally |
| 🚀 Zero Setup | Pure Bash — no Python/Ruby/Node required |
| 🎨 Beautiful UI | Color-coded terminal output with spinners and progress bars |

---

## 📦 Requirements

### Required (always available on Linux/macOS)
```
bash 5+    awk    sed    grep    find    sort    uniq    wc    date
```

### Optional (unlocks extra features)
```
nmap        → Advanced port scanning
openssl     → SSL/TLS analysis
curl        → HTTP requests, recon, API testing
dig / host  → DNS reconnaissance
whois       → Domain information
docker      → Docker security audit
git         → Git history scanning
ss / netstat → Network monitoring
```

Install all optional tools on Ubuntu/Debian:
```bash
sudo apt update && sudo apt install -y \
  nmap openssl curl dnsutils whois docker.io git iproute2
```

Install on macOS:
```bash
brew install nmap openssl curl bind whois git
```

---

## 🚀 Installation

### Option 1 — Clone (Recommended)
```bash
git clone https://github.com/demiyan-dissanayake/cyberforge.git
cd cyberforge
chmod +x cyberforge.sh
./cyberforge.sh help
```

### Option 2 — Direct Download
```bash
curl -O https://raw.githubusercontent.com/demiyan-dissanayake/cyberforge/main/cyberforge.sh
chmod +x cyberforge.sh
./cyberforge.sh help
```

### Option 3 — Global Install
```bash
sudo cp cyberforge.sh /usr/local/bin/cyberforge
cyberforge help
```

---

## ⚡ Quick Start

```bash
# Show all modules
./cyberforge.sh help

# System overview
./cyberforge.sh sysinfo

# Recon a domain
./cyberforge.sh recon example.com

# Scan ports
./cyberforge.sh portscan 192.168.1.1 1-1024

# Audit a website
./cyberforge.sh webaudit https://example.com

# Generate a strong password
./cyberforge.sh passgen 32 paranoid

# Encode/Decode
./cyberforge.sh encodedec encode base64 "Hello World"
./cyberforge.sh encodedec decode base64 "SGVsbG8gV29ybGQ="

# Crack a hash
./cyberforge.sh hashcrack auto 5f4dcc3b5aa765d61d8327deb882cf99

# Full security report
./cyberforge.sh report
```

---

## 🔐 Cyber Security Modules

### `recon` — Passive & Active Reconnaissance
```bash
./cyberforge.sh recon <host|domain|ip>
```
- WHOIS lookup (registrar, dates, nameservers)
- IP resolution + GeoIP (city, country, ISP)
- HTTP server fingerprinting
- Robots.txt, sitemap.xml, security.txt discovery

---

### `portscan` — TCP Port Scanner
```bash
./cyberforge.sh portscan <host> [port-range]
# Examples:
./cyberforge.sh portscan 192.168.1.1
./cyberforge.sh portscan 192.168.1.1 1-65535
./cyberforge.sh portscan target.com 80-8080
```
- Uses **nmap** (SYN scan + service detection) if available
- Falls back to **pure bash /dev/tcp** scanner if nmap missing
- Built-in service name mapping (FTP, SSH, HTTP, MySQL, etc.)
- Visual progress bar

---

### `sslenum` — SSL/TLS Analyzer
```bash
./cyberforge.sh sslenum <host> [port]
./cyberforge.sh sslenum example.com 443
```
- Certificate info (subject, issuer, expiry, fingerprint)
- Protocol support (SSLv2, SSLv3, TLS 1.0–1.3)
- Weak cipher detection (RC4, DES, NULL, EXPORT, MD5)
- Expiry warning (alerts if < 30 days)

---

### `dnsrecon` — DNS Enumeration
```bash
./cyberforge.sh dnsrecon <domain>
./cyberforge.sh dnsrecon example.com
```
- All record types: A, AAAA, MX, NS, TXT, CNAME, SOA, SRV
- Zone Transfer attempt (AXFR)
- 28 common subdomain brute-force checks

---

### `webaudit` — Web Application Security Audit
```bash
./cyberforge.sh webaudit <url>
./cyberforge.sh webaudit https://example.com
```
- 8 security headers check (HSTS, CSP, X-Frame-Options, etc.)
- Server/backend version disclosure detection
- 22 sensitive path discovery (`.git`, `.env`, admin panels, etc.)
- Cookie security flags (HttpOnly, Secure, SameSite)

---

### `vulnscan` — Vulnerability Scanner
```bash
./cyberforge.sh vulnscan <host>
```
- Default credential exposure checks (Redis, MongoDB, Elasticsearch)
- Shellshock probe
- `.git` directory exposure
- Directory listing check
- Open redirect probing

---

### `hashcrack` — Hash Identifier & Cracker
```bash
./cyberforge.sh hashcrack auto <hash>
./cyberforge.sh hashcrack md5 5f4dcc3b5aa765d61d8327deb882cf99
./cyberforge.sh hashcrack sha256 <hash>
```
- Auto-detects: MD5, SHA-1, SHA-256, SHA-512, bcrypt, SHA-crypt
- Built-in 40-password wordlist
- Supports custom wordlist at `~/.cyberforge/wordlists/rockyou_mini.txt`
- Supports: md5, sha1, sha256, sha512

---

### `passgen` — Secure Password Generator
```bash
./cyberforge.sh passgen [length] [mode]
# Modes: alpha | alnum | special | paranoid
./cyberforge.sh passgen 20 special
./cyberforge.sh passgen 64 paranoid
```
- Reads from `/dev/urandom` (cryptographically secure)
- Generates 10 passwords per run
- Shows strength rating (WEAK / MEDIUM / STRONG / ULTRA-STRONG)
- Displays entropy information

---

### `encodedec` — Encode / Decode / Hash
```bash
./cyberforge.sh encodedec <encode|decode> <scheme> <text>
# Schemes: base64 | hex | url | rot13 | binary | md5 | sha1 | sha256 | sha512
./cyberforge.sh encodedec encode hex "secret"
./cyberforge.sh encodedec decode url "hello%20world"
./cyberforge.sh encodedec encode sha256 "password"
```

---

### `netmon` — Network Monitor
```bash
./cyberforge.sh netmon
```
- All listening TCP/UDP ports with process names
- Active established connections
- Routing table display

---

### `logaudit` — Log Forensics
```bash
./cyberforge.sh logaudit
```
- SSH auth failure count and top attacking IPs
- Recent sudo usage trail
- CyberForge own audit log

---

### `firewall` — Firewall Inspector
```bash
./cyberforge.sh firewall
```
- UFW status and rules
- iptables rule listing
- 7 hardening recommendations

---

## 🛠️ Software Engineering Modules

### `sysinfo` — System Fingerprint
```bash
./cyberforge.sh sysinfo
```
- OS, kernel, architecture, hostname, uptime
- CPU model, cores, frequency, load average
- Memory usage with visual bar
- Network interfaces and IPs
- Logged-in users

---

### `procmon` — Process Monitor
```bash
./cyberforge.sh procmon
```
- Top 15 CPU consumers
- Top 10 memory consumers
- All open network connections

---

### `codeaudit` — Static Code Analysis
```bash
./cyberforge.sh codeaudit [/path/to/project]
./cyberforge.sh codeaudit /home/user/myapp
```
- 14 secret/credential patterns
- TODO / FIXME / HACK / XXX count
- File statistics by language
- Large files (>500 lines) complexity warning

---

### `sshaudit` — SSH Hardening Audit
```bash
./cyberforge.sh sshaudit
```
- Checks `/etc/ssh/sshd_config` for 9 critical settings
- Key file permission validation
- Key type and fingerprint display

---

### `dockeraudit` — Docker Security Audit
```bash
./cyberforge.sh dockeraudit
```
- Running containers overview
- Root-user container detection
- Privileged container detection
- Ports exposed to 0.0.0.0 (all interfaces)

---

### `gitcheck` — Git Security Scanner
```bash
./cyberforge.sh gitcheck
```
- Scans **entire git history** for 10 secret patterns
- .gitignore coverage check (14 required entries)
- Large object detection in git history

---

### `apidebug` — REST API Tester
```bash
./cyberforge.sh apidebug <url> [METHOD] [body]
./cyberforge.sh apidebug https://api.example.com/users
./cyberforge.sh apidebug https://api.example.com/users POST '{"name":"test"}'
```
- HTTP status code with color coding
- Response time measurement
- Content-Type and body size
- Response preview (first 30 lines)

---

### `envcheck` — Dev Environment Health
```bash
./cyberforge.sh envcheck
```
- Checks 20 essential developer tools
- Shows installed versions
- Flags missing tools

---

### `diskaudit` — Disk Analysis
```bash
./cyberforge.sh diskaudit
```
- Partition usage with high-usage warnings (>80%)
- Top 15 largest files (system-wide)
- Top 10 largest directories

---

### `report` — Full Security Report
```bash
./cyberforge.sh report
```
- Runs: sysinfo + procmon + netmon + sshaudit + firewall + diskaudit + envcheck + logaudit + gitcheck
- Strips ANSI colors — clean plain text
- Saved to `~/.cyberforge/reports/cyberforge_report_TIMESTAMP.txt`

---

## 📁 File Structure

```
cyberforge/
├── cyberforge.sh          # Main tool (single file, all modules)
├── README.md              # This file
├── LICENSE                # MIT License
├── CHANGELOG.md           # Version history
├── .gitignore             # Git ignore rules
├── docs/
│   └── USAGE.md           # Extended usage guide
└── wordlists/
    └── .gitkeep           # Place rockyou_mini.txt here
```

**Runtime files** (auto-created at `~/.cyberforge/`):
```
~/.cyberforge/
├── cyberforge.log         # Audit log
├── reports/               # Generated reports
└── wordlists/             # Custom wordlists
```

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/new-module`
3. Commit your changes: `git commit -m "feat: add new-module"`
4. Push to the branch: `git push origin feat/new-module`
5. Open a Pull Request

Please follow the existing code style and add documentation for new modules.

---

## 📜 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## ⚖️ License

MIT License — see [LICENSE](LICENSE) for details.

---

## 👤 Author

**Demiyan Dissanayake**  
GitHub: [@demiyan-dissanayake](https://github.com/Dexel-Software-Solutions)

---

<div align="center">

**⭐ Star this repo if you find it useful!**

Made with ❤️ and pure Bash

</div>
