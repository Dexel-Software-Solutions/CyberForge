# Changelog

All notable changes to CyberForge are documented here.  
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [2.0.0] — 2025-07-01

### Added
- `recon`       — Passive & active reconnaissance (WHOIS, GeoIP, HTTP fingerprint)
- `portscan`    — TCP port scanner (nmap + pure bash fallback)
- `vulnscan`    — Common vulnerability & misconfiguration checks
- `sslenum`     — SSL/TLS protocol, cipher, and certificate analysis
- `dnsrecon`    — DNS record enumeration + AXFR + subdomain brute-force
- `webaudit`    — Web application security header & path audit
- `hashcrack`   — Hash identifier + dictionary crack (MD5/SHA-1/SHA-256/SHA-512)
- `passgen`     — Cryptographically secure password generator with entropy scoring
- `encodedec`   — Encode/decode: base64, hex, URL, ROT13, SHA family
- `netmon`      — Real-time network connection and port monitor
- `logaudit`    — Auth log forensics and brute-force IP detection
- `firewall`    — UFW + iptables inspector with hardening tips
- `sysinfo`     — Full system fingerprint (OS, CPU, RAM, network)
- `procmon`     — Top CPU/MEM process monitor
- `diskaudit`   — Disk usage analysis + large file detection
- `sshaudit`    — sshd_config audit + key permission validation
- `codeaudit`   — Static code analysis (secrets, TODOs, complexity)
- `envcheck`    — Developer environment health check (20 tools)
- `apidebug`    — REST API tester with response analysis
- `dockeraudit` — Docker container security audit
- `gitcheck`    — Git history secret scanner + .gitignore validator
- `report`      — Full plaintext security report generator
- `update`      — Update checker
- Spinner animation, color-coded output, progress bars
- Audit logging to `~/.cyberforge/cyberforge.log`
- Project config support via `.cyberforge` file

### Developer
- Demiyan Dissanayake

---

## [1.0.0] — 2025-01-01

### Added
- Initial release
- Basic recon and port scanning modules
