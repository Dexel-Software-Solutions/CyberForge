<div align="center">


<br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=22&duration=3000&pause=1000&color=00E676&center=true&vCenter=true&width=600&lines=CyberForge+v2.0.0+%F0%9F%94%A5;Pure+Bash+Security+Toolkit;Recon+%7C+Scan+%7C+Audit+%7C+Crack;21+Modules.+Zero+Dependencies.;FOR+AUTHORIZED+USE+ONLY" alt="Typing SVG" />

<br><br>

[![Version](https://img.shields.io/badge/version-2.0.0-red.svg?style=for-the-badge&logo=github)](https://github.com/Dexel-Software-Solutions/CyberForge)
[![Shell](https://img.shields.io/badge/shell-bash%205%2B-brightgreen.svg?style=for-the-badge&logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL-blue.svg?style=for-the-badge&logo=linux)](https://github.com/Dexel-Software-Solutions/CyberForge)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Author](https://img.shields.io/badge/author-Demiyan%20Dissanayake-purple.svg?style=for-the-badge&logo=github)](https://github.com/Dexel-Software-Solutions)

<br>

> ⚠️ **FOR AUTHORIZED TESTING AND EDUCATIONAL USE ONLY.**
> Unauthorized use against systems you do not own is **illegal**.

</div>

---

## 🔥 What is CyberForge?

**CyberForge** is a pure-Bash advanced security and software engineering toolkit — zero Python, zero Ruby, zero Node required. One script, **21 modules**, full power.

<div align="center">

![Modules](https://img.shields.io/badge/Modules-21-00e676?style=flat-square&logo=target)
![Zero Setup](https://img.shields.io/badge/Zero_Setup-Pure_Bash-brightgreen?style=flat-square&logo=gnu-bash)
![Reports](https://img.shields.io/badge/Reports-HTML_Ready-blue?style=flat-square&logo=html5)
![Entropy](https://img.shields.io/badge/Passwords-256_bit_entropy-red?style=flat-square&logo=keepassxc)

</div>

---

## ✨ Feature Overview

<div align="center">

| 🔐 Cyber Security | 🛠️ Software Engineering | 🔑 Crypto Tools |
|:---|:---|:---|
| Passive & Active Recon | System Fingerprint | Hash Identifier & Cracker |
| TCP Port Scanner (nmap / bash) | Static Code Analysis | Secure Password Generator |
| SSL/TLS Auditor | SSH Hardening Audit | Base64 / Hex / URL / ROT13 |
| DNS Enumeration + AXFR | Docker Security Audit | MD5, SHA1, SHA256, SHA512 |
| Web Application Audit | Git History Scanner | Encode / Decode / Hash |
| Vulnerability Scanner | REST API Tester | Custom Wordlist Support |
| Log Forensics | Dev Environment Check | `/dev/urandom` sourced |
| Firewall Inspector | Disk Analysis | Entropy Display |
| Network Monitor | Process Monitor | Strength Rating |
| Full Security Report | Git Security Scanner | — |

</div>

---

## 🚀 Installation

```bash
# Option 1 — Clone (Recommended)
git clone https://github.com/Dexel-Software-Solutions/CyberForge.git
cd CyberForge
chmod +x cyberforge.sh
./cyberforge.sh help

# Option 2 — Direct Download
curl -O https://raw.githubusercontent.com/Dexel-Software-Solutions/CyberForge/main/cyberforge.sh
chmod +x cyberforge.sh

# Option 3 — Global Install
sudo cp cyberforge.sh /usr/local/bin/cyberforge
cyberforge help
```

---

## ⚡ Quick Start

```bash
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

# Encode / Decode
./cyberforge.sh encodedec encode base64 "Hello World"
./cyberforge.sh encodedec decode base64 "SGVsbG8gV29ybGQ="

# Crack a hash
./cyberforge.sh hashcrack auto 5f4dcc3b5aa765d61d8327deb882cf99

# Full security report
./cyberforge.sh report
```

---

## 🔐 Cyber Security Modules

<details>
<summary><b>📡 recon — Passive & Active Reconnaissance</b></summary>
<br>

```bash
./cyberforge.sh recon <host|domain|ip>
```

- WHOIS lookup (registrar, dates, nameservers)
- IP resolution + GeoIP (city, country, ISP)
- HTTP server fingerprinting
- Robots.txt, sitemap.xml, security.txt discovery

</details>

<details>
<summary><b>🛰️ portscan — TCP Port Scanner</b></summary>
<br>

```bash
./cyberforge.sh portscan <host> [port-range]
./cyberforge.sh portscan 192.168.1.1 1-65535
./cyberforge.sh portscan target.com 80-8080
```

- Uses **nmap** (SYN scan + service detection) if available
- Falls back to **pure bash /dev/tcp** scanner if nmap is missing
- Built-in service name mapping (FTP, SSH, HTTP, MySQL, etc.)
- Visual progress bar

</details>

<details>
<summary><b>🔒 sslenum — SSL/TLS Analyzer</b></summary>
<br>

```bash
./cyberforge.sh sslenum <host> [port]
./cyberforge.sh sslenum example.com 443
```

- Certificate info (subject, issuer, expiry, fingerprint)
- Protocol support: SSLv2, SSLv3, TLS 1.0–1.3
- Weak cipher detection (RC4, DES, NULL, EXPORT, MD5)
- Expiry warning (alerts if < 30 days remaining)

</details>

<details>
<summary><b>🌐 dnsrecon — DNS Enumeration</b></summary>
<br>

```bash
./cyberforge.sh dnsrecon <domain>
```

- All record types: A, AAAA, MX, NS, TXT, CNAME, SOA, SRV
- Zone Transfer attempt (AXFR)
- 28 common subdomain brute-force checks

</details>

<details>
<summary><b>🕵️ webaudit — Web Application Security Audit</b></summary>
<br>

```bash
./cyberforge.sh webaudit <url>
./cyberforge.sh webaudit https://example.com
```

- 8 security headers check (HSTS, CSP, X-Frame-Options, etc.)
- Server/backend version disclosure detection
- 22 sensitive path discovery (`.git`, `.env`, admin panels, etc.)
- Cookie security flags (HttpOnly, Secure, SameSite)

</details>

<details>
<summary><b>💥 vulnscan — Vulnerability Scanner</b></summary>
<br>

```bash
./cyberforge.sh vulnscan <host>
```

- Default credential exposure checks (Redis, MongoDB, Elasticsearch)
- Shellshock probe
- `.git` directory exposure
- Directory listing check
- Open redirect probing

</details>

<details>
<summary><b>🔑 hashcrack — Hash Identifier & Cracker</b></summary>
<br>

```bash
./cyberforge.sh hashcrack auto <hash>
./cyberforge.sh hashcrack md5 5f4dcc3b5aa765d61d8327deb882cf99
./cyberforge.sh hashcrack sha256 <hash>
```

- Auto-detects: MD5, SHA-1, SHA-256, SHA-512, bcrypt, SHA-crypt
- Built-in 40-password wordlist
- Supports custom wordlist at `~/.cyberforge/wordlists/rockyou_mini.txt`

</details>

<details>
<summary><b>🔐 passgen — Secure Password Generator</b></summary>
<br>

```bash
./cyberforge.sh passgen [length] [mode]
# Modes: alpha | alnum | special | paranoid
./cyberforge.sh passgen 64 paranoid
```

- Reads from `/dev/urandom` (cryptographically secure)
- Generates 10 passwords per run
- Shows strength rating: WEAK / MEDIUM / STRONG / ULTRA-STRONG
- Displays full entropy information

</details>

<details>
<summary><b>🔄 encodedec — Encode / Decode / Hash</b></summary>
<br>

```bash
./cyberforge.sh encodedec <encode|decode> <scheme> <text>
# Schemes: base64 | hex | url | rot13 | binary | md5 | sha1 | sha256 | sha512
```

</details>

---

## 🛠️ Software Engineering Modules

<details>
<summary><b>💻 sysinfo — System Fingerprint</b></summary>
<br>

```bash
./cyberforge.sh sysinfo
```

OS, kernel, CPU, memory, network interfaces, logged-in users.

</details>

<details>
<summary><b>🔍 codeaudit — Static Code Analysis</b></summary>
<br>

```bash
./cyberforge.sh codeaudit [/path/to/project]
```

- 14 secret/credential patterns
- TODO / FIXME / HACK / XXX count
- File statistics by language
- Large file complexity warning (>500 lines)

</details>

<details>
<summary><b>🐳 dockeraudit — Docker Security Audit</b></summary>
<br>

```bash
./cyberforge.sh dockeraudit
```

- Running containers overview
- Root-user container detection
- Privileged container detection
- Ports exposed to 0.0.0.0

</details>

<details>
<summary><b>📜 gitcheck — Git Security Scanner</b></summary>
<br>

```bash
./cyberforge.sh gitcheck
```

- Scans **entire git history** for 10 secret patterns
- .gitignore coverage check (14 required entries)
- Large object detection in git history

</details>

<details>
<summary><b>📊 report — Full Security Report</b></summary>
<br>

```bash
./cyberforge.sh report
```

Runs: `sysinfo + procmon + netmon + sshaudit + firewall + diskaudit + envcheck + logaudit + gitcheck`

Saved to `~/.cyberforge/reports/cyberforge_report_TIMESTAMP.txt`

</details>

---

## 📦 Requirements

### Always available (Linux/macOS)
```
bash 5+  awk  sed  grep  find  sort  uniq  wc  date
```

### Optional — unlocks extra features
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

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install -y \
  nmap openssl curl dnsutils whois docker.io git iproute2

# macOS
brew install nmap openssl curl bind whois git
```

---

## 📁 File Structure

```
cyberforge/
├── cyberforge.sh          # Main tool (single file, all modules)
├── README.md
├── LICENSE
├── CHANGELOG.md
├── docs/
│   └── USAGE.md
└── wordlists/
    └── .gitkeep           # Place rockyou_mini.txt here
```

**Runtime files** (auto-created):
```
~/.cyberforge/
├── cyberforge.log
├── reports/
└── wordlists/
```

---

## 🤝 Contributing

```bash
# 1. Fork the repo
# 2. Create a feature branch
git checkout -b feat/new-module

# 3. Commit your changes
git commit -m "feat: add new-module"

# 4. Push and open a Pull Request
git push origin feat/new-module
```

Please follow the existing code style and add documentation for new modules.

---

## 📈 Activity

<div align="center">

[![Activity Graph](https://github-readme-activity-graph.vercel.app/graph?username=Dexel-Software-Solutions&theme=react-dark&bg_color=0a0e14&color=00e676&line=00e676&point=ffffff&area=true&hide_border=true)](https://github.com/demiyan-dissanayake)

</div>

---

<div align="center">

**⭐ Star this repo if you find it useful!**

Made with ❤️ and pure Bash by [Demiyan Dissanayake](https://github.com/Dexel-Software-Solutions)

[![GitHub stars](https://img.shields.io/github/stars/Dexel-Software-Solutions/CyberForge?style=social)](https://github.com/Dexel-Software-Solutions/CyberForge)
[![GitHub forks](https://img.shields.io/github/forks/Dexel-Software-Solutions/CyberForge?style=social)](https://github.com/Dexel-Software-Solutions/CyberForge)
[![GitHub watchers](https://img.shields.io/github/watchers/Dexel-Software-Solutions/CyberForge?style=social)](https://github.com/Dexel-Software-Solutions/CyberForge)

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=0,2,2,5,30&height=100&section=footer" width="100%"/>

</div>
