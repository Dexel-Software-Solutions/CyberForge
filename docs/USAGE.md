# CyberForge — Extended Usage Guide

> **Developer:** Demiyan Dissanayake  
> **Version:** 2.0.0

---

## Installation Methods

### System-wide (Recommended for daily use)
```bash
git clone https://github.com/demiyan-dissanayake/cyberforge.git
cd cyberforge
sudo cp cyberforge.sh /usr/local/bin/cyberforge
sudo chmod +x /usr/local/bin/cyberforge

# Now use from anywhere:
cyberforge help
cyberforge sysinfo
```

### Project-local
```bash
git clone https://github.com/demiyan-dissanayake/cyberforge.git
cd cyberforge
chmod +x cyberforge.sh
./cyberforge.sh help
```

---

## Shell Alias (optional convenience)
Add to your `~/.bashrc` or `~/.zshrc`:
```bash
alias cf="/path/to/cyberforge.sh"
alias cf-recon="cyberforge recon"
alias cf-audit="cyberforge webaudit"
```

---

## Adding a Custom Wordlist (hashcrack)

Place any wordlist at:
```
~/.cyberforge/wordlists/rockyou_mini.txt
```

Download rockyou (common source):
```bash
# From SecLists
curl -L -o ~/.cyberforge/wordlists/rockyou_mini.txt \
  https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt
```

---

## Typical Workflows

### Web Application Pentest Workflow
```bash
# Step 1 — Recon
cyberforge recon target.com

# Step 2 — DNS
cyberforge dnsrecon target.com

# Step 3 — Port scan
cyberforge portscan target.com 1-65535

# Step 4 — SSL check
cyberforge sslenum target.com 443

# Step 5 — Web audit
cyberforge webaudit https://target.com

# Step 6 — Vulnerability scan
cyberforge vulnscan target.com
```

### Developer Daily Workflow
```bash
# Morning check
cyberforge envcheck

# Before committing code
cyberforge codeaudit .
cyberforge gitcheck

# Check your server
cyberforge sysinfo
cyberforge procmon
cyberforge netmon
```

### CI/CD Integration (GitHub Actions example)
```yaml
name: Security Audit
on: [push, pull_request]
jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run CyberForge Code Audit
        run: |
          chmod +x ./cyberforge.sh
          ./cyberforge.sh codeaudit .
          ./cyberforge.sh gitcheck
```

---

## Understanding Output

| Prefix | Meaning |
|--------|---------|
| `[✔]` Green  | Check passed, no issues |
| `[!]` Yellow | Warning — review recommended |
| `[✘]` Red    | Critical issue — action required |
| `[i]` Cyan   | Informational |
| `[+]` Purple | Finding / discovery |
| `[→]` Red    | Attack vector / exploit path |
| `[*]` Blue   | Step / process update |

---

## Report Files

Reports are saved to:
```
~/.cyberforge/reports/cyberforge_report_YYYYMMDD_HHMMSS.txt
```

View a report:
```bash
cat ~/.cyberforge/reports/cyberforge_report_*.txt
less -R ~/.cyberforge/reports/cyberforge_report_*.txt
```

---

## Audit Log

Every module call is logged to:
```
~/.cyberforge/cyberforge.log
```

View recent actions:
```bash
tail -50 ~/.cyberforge/cyberforge.log
grep "AUDIT" ~/.cyberforge/cyberforge.log
```

---

## Troubleshooting

**"Permission denied" on scan modules**  
Some modules (firewall, logaudit) need root:
```bash
sudo ./cyberforge.sh firewall
sudo ./cyberforge.sh logaudit
```

**"nmap not found" on portscan**  
Install nmap or use the built-in bash fallback (automatic):
```bash
sudo apt install nmap    # Ubuntu/Debian
brew install nmap        # macOS
```

**SSL module errors**  
```bash
sudo apt install openssl
```

**DNS module errors**  
```bash
sudo apt install dnsutils   # provides dig, host
sudo apt install whois
```

---

## Security Notes

1. **Always get written permission** before running scans on any system
2. CyberForge logs all operations to `~/.cyberforge/cyberforge.log`
3. Port scanning without authorization may be **illegal** in your jurisdiction
4. The `vulnscan` module only does **safe, passive checks** — no exploitation
5. `hashcrack` is for recovering **your own passwords** only

---

## Module Development Guide

To add a new module to CyberForge:

```bash
# 1. Add function in cyberforge.sh
mod_mymodule() {
  local target="${1:-}"
  [[ -z "$target" ]] && { err "Usage: cyberforge.sh mymodule <arg>"; return 1; }

  _hdr "  🔧  MY MODULE: ${target}"
  log_audit "mymodule $target"

  _sec "Section Name"
  # ... your logic here ...
  ok "Done"
  _sec_end
}

# 2. Add to main() case statement
mymodule) mod_mymodule "$@" ;;

# 3. Add to _help()
"mymodule    │ Description of what it does"

# 4. Update README.md and CHANGELOG.md
```

Available helper functions:
- `ok "msg"` — green success
- `warn "msg"` — yellow warning  
- `err "msg"` — red error
- `info "msg"` — cyan info
- `found "msg"` — purple finding
- `attack "msg"` — red attack vector
- `_sec "Title"` / `_sec_end` — section box
- `_row "label" "value" "$COLOR"` — key-value row
- `_spin_start "msg"` / `_spin_stop` — spinner
- `log_audit "msg"` — write to audit log
- `_check_cmd cmd` — returns true if command exists
- `_require cmd1 cmd2` — exit with error if missing
