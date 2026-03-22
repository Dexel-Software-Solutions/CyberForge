#!/usr/bin/env bash
# ============================================================
#  CyberForge v2.1.0
#  Advanced SE & Cyber Security Toolkit
#  Developer : Demiyan Dissanayake
#  License   : MIT
#  Platform  : Linux / macOS / Windows Git Bash / WSL
#  GitHub    : github.com/demiyan-dissanayake/cyberforge
# ============================================================
#  DISCLAIMER: For EDUCATIONAL and AUTHORIZED TESTING only.
#  Unauthorized use is ILLEGAL. Use responsibly.
# ============================================================

set -uo pipefail

# ── Platform Detection ────────────────────────────────────────
_OS="$(uname -s 2>/dev/null || echo 'Unknown')"
_IS_WIN=false; _IS_MAC=false; _IS_LIN=false
case "$_OS" in
  MINGW*|CYGWIN*|MSYS*) _IS_WIN=true ;;
  Darwin*)              _IS_MAC=true ;;
  Linux*)               _IS_LIN=true ;;
esac

# ── Metadata ─────────────────────────────────────────────────
readonly VER="2.1.0"
readonly AUTHOR="Demiyan Dissanayake"
readonly GITHUB="github.com/demiyan-dissanayake/cyberforge"

# ── Colors ───────────────────────────────────────────────────
R='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
RED='\033[0;31m';  GRN='\033[0;32m';  YLW='\033[0;33m'
CYN='\033[0;36m';  MGT='\033[0;35m'
BRED='\033[1;31m'; BGRN='\033[1;32m'; BYLW='\033[1;33m'
BBLU='\033[1;34m'; BMGT='\033[1;35m'; BCYN='\033[1;36m'
BWHT='\033[1;37m'

# ── Dirs ─────────────────────────────────────────────────────
CF_DIR="${HOME}/.cyberforge"
CF_LOG="${CF_DIR}/cf.log"
CF_REPORTS="${CF_DIR}/reports"
CF_WL="${CF_DIR}/wordlists"

# ── Portable Helpers ─────────────────────────────────────────
_rep() {
  # Repeat char $1 exactly $2 times — no seq, no {n..m}
  local c="$1" n="$2" out="" i=0
  while [ $i -lt $n ]; do out="${out}${c}"; i=$((i+1)); done
  printf '%s' "$out"
}

_line() {
  local ch="${1:--}" w="${2:-70}"
  _rep "$ch" "$w"; printf '\n'
}

_bar() {
  # ASCII bar for Windows, block chars for others
  local f="$1" e="$2"
  if $_IS_WIN; then
    printf '%s%s' "$(_rep '#' "$f")" "$(_rep '.' "$e")"
  else
    printf '%s%s' "$(_rep '█' "$f")" "$(_rep '░' "$e")"
  fi
}

_init() {
  mkdir -p "$CF_DIR" "$CF_REPORTS" "$CF_WL" 2>/dev/null || true
  touch "$CF_LOG" 2>/dev/null || true
}

_log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')][$1] $2" >> "$CF_LOG" 2>/dev/null || true; }
audit() { _log "AUDIT" "$*"; }
linfo() { _log "INFO"  "$*"; }

# ── Print Helpers ─────────────────────────────────────────────
_hdr() {
  local t="$1" w=74
  local pad=$(( (w - ${#t}) / 2 ))
  local rpad=$(( w - pad - ${#t} ))
  echo
  echo -e "${BRED}$(_line '=' $w)${R}"
  printf "${BRED}|${R}${BOLD}%*s%s%*s${BRED}|${R}\n" "$pad" "" "$t" "$rpad" ""
  echo -e "${BRED}$(_line '=' $w)${R}"
  echo
}

_sec() {
  local t="$1"
  local d=$(( 62 - ${#t} ))
  [ $d -lt 2 ] && d=2
  echo
  echo -e "${BCYN}  +-- ${BOLD}${t}${R}${BCYN} $(_rep '-' $d)${R}"
}

_end() { echo -e "${BCYN}  +$(_rep '-' 72)${R}"; }

_row() {
  local l="$1" v="$2" c="${3:-$R}"
  printf "  ${DIM}|${R}  ${BOLD}%-28s${R} ${c}%s${R}\n" "$l" "$v"
}

ok()     { echo -e "  ${BGRN}[OK]${R}    ${BOLD}$*${R}"; }
warn()   { echo -e "  ${BYLW}[!!]${R}    ${BOLD}$*${R}"; }
err()    { echo -e "  ${BRED}[ERR]${R}   ${BOLD}$*${R}"; }
info()   { echo -e "  ${BCYN}[--]${R}    $*"; }
found()  { echo -e "  ${BMGT}[+]${R}     ${BOLD}$*${R}"; }
attack() { echo -e "  ${BRED}[>>]${R}    $*"; }
step()   { echo -e "  ${BBLU}[*]${R}     $*"; }

_chk()   { command -v "$1" >/dev/null 2>&1; }

_need() {
  local miss=()
  for d in "$@"; do _chk "$d" || miss+=("$d"); done
  if [ ${#miss[@]} -gt 0 ]; then
    err "Missing: ${miss[*]}"
    $_IS_WIN && info "Windows: winget / choco / WSL" || info "sudo apt install ${miss[*]}"
    return 1
  fi
}

# ── Banner ────────────────────────────────────────────────────
_banner() {
  printf '\033[2J\033[H' 2>/dev/null || echo
  echo -e "${BRED}"
  echo "  ########################################################"
  echo "  ##                                                    ##"
  echo "  ##   CyberForge  v${VER}                               ##"
  echo "  ##   Advanced SE & Cyber Security Toolkit             ##"
  echo "  ##                                                    ##"
  echo "  ##   Developer : ${AUTHOR}                  ##"
  echo "  ##   GitHub    : ${GITHUB}          ##"
  echo "  ##   Platform  : ${_OS}                    ##"
  echo "  ##                                                    ##"
  echo "  ########################################################"
  echo -e "${R}"
  echo -e "  ${BRED}[!] FOR AUTHORIZED TESTING AND EDUCATION ONLY${R}"
  echo
}

# ── Help ─────────────────────────────────────────────────────
_help() {
  _banner
  echo -e "${BWHT}USAGE:  ${CYN}./cyberforge.sh ${BYLW}<module> ${DIM}[options]${R}"
  echo
  echo -e "${BWHT}== CYBER SECURITY ============================================${R}"
  echo -e "  ${BYLW}recon       ${DIM}|${R}  Passive recon: WHOIS, GeoIP, HTTP fingerprint"
  echo -e "  ${BYLW}portscan    ${DIM}|${R}  TCP port scanner (nmap or bash fallback)"
  echo -e "  ${BYLW}vulnscan    ${DIM}|${R}  Common vulnerability & misconfiguration checks"
  echo -e "  ${BYLW}sslenum     ${DIM}|${R}  SSL/TLS protocol, cipher, certificate analysis"
  echo -e "  ${BYLW}dnsrecon    ${DIM}|${R}  DNS enumeration + zone transfer + subdomain brute"
  echo -e "  ${BYLW}webaudit    ${DIM}|${R}  Web security headers, paths, cookie flags"
  echo -e "  ${BYLW}hashcrack   ${DIM}|${R}  Hash identifier + dictionary crack"
  echo -e "  ${BYLW}passgen     ${DIM}|${R}  Cryptographically secure password generator"
  echo -e "  ${BYLW}encodedec   ${DIM}|${R}  Encode/decode: base64 hex url rot13 sha256..."
  echo -e "  ${BYLW}netmon      ${DIM}|${R}  Active connections and listening ports"
  echo -e "  ${BYLW}logaudit    ${DIM}|${R}  Log forensics and anomaly detection"
  echo -e "  ${BYLW}firewall    ${DIM}|${R}  Firewall inspector + hardening tips"
  echo
  echo -e "${BWHT}== SOFTWARE ENGINEERING ======================================${R}"
  echo -e "  ${BYLW}sysinfo     ${DIM}|${R}  Full system fingerprint (OS, CPU, RAM, network)"
  echo -e "  ${BYLW}procmon     ${DIM}|${R}  Top CPU / Memory process monitor"
  echo -e "  ${BYLW}diskaudit   ${DIM}|${R}  Disk usage and large file detection"
  echo -e "  ${BYLW}sshaudit    ${DIM}|${R}  SSH config audit and key permission check"
  echo -e "  ${BYLW}codeaudit   ${DIM}|${R}  Static analysis: secrets, TODOs, complexity"
  echo -e "  ${BYLW}envcheck    ${DIM}|${R}  Dev environment health (20 tools checked)"
  echo -e "  ${BYLW}apidebug    ${DIM}|${R}  REST API tester + response analyzer"
  echo -e "  ${BYLW}dockeraudit ${DIM}|${R}  Docker container security audit"
  echo -e "  ${BYLW}gitcheck    ${DIM}|${R}  Git history secret scan + .gitignore validator"
  echo -e "  ${BYLW}report      ${DIM}|${R}  Full security report saved to disk"
  echo
  echo -e "${BWHT}EXAMPLES:${R}"
  echo -e "  ${DIM}./cyberforge.sh sysinfo"
  echo -e "  ./cyberforge.sh recon example.com"
  echo -e "  ./cyberforge.sh portscan 192.168.1.1 1-1024"
  echo -e "  ./cyberforge.sh webaudit https://example.com"
  echo -e "  ./cyberforge.sh passgen 32 special"
  echo -e "  ./cyberforge.sh hashcrack auto 5f4dcc3b5aa765d61d8327deb882cf99${R}"
  echo
}

# ============================================================
#  MODULE: RECON
# ============================================================
mod_recon() {
  local tgt="${1:-}"
  [ -z "$tgt" ] && { err "Usage: cyberforge.sh recon <host|ip>"; return 1; }
  tgt="${tgt#http://}"; tgt="${tgt#https://}"; tgt="${tgt%%/*}"

  _hdr "  RECONNAISSANCE: ${tgt}"
  audit "recon $tgt"

  _sec "WHOIS"
  if _chk whois; then
    whois "$tgt" 2>/dev/null \
      | grep -iE 'registrar|created|expir|name.server|org|country' \
      | head -15 \
      | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
  else
    warn "whois not installed"
    $_IS_WIN && info "Try: choco install whois  OR use WSL"
  fi
  _end

  _sec "IP Resolution"
  local ip=""
  if _chk nslookup; then
    ip="$(nslookup "$tgt" 2>/dev/null | awk '/^Address:/{print $2}' | grep -v '#' | head -1 || true)"
  elif _chk dig; then
    ip="$(dig +short A "$tgt" 2>/dev/null | head -1 || true)"
  elif _chk host; then
    ip="$(host "$tgt" 2>/dev/null | awk '/has address/{print $NF}' | head -1 || true)"
  fi

  if [ -n "$ip" ]; then
    found "IP: $ip"
    if _chk curl; then
      local g; g="$(curl -s --max-time 6 "https://ipinfo.io/${ip}/json" 2>/dev/null || echo '{}')"
      info "City    : $(echo "$g" | grep '"city"'    | cut -d'"' -f4)"
      info "Country : $(echo "$g" | grep '"country"' | cut -d'"' -f4)"
      info "ISP/Org : $(echo "$g" | grep '"org"'     | cut -d'"' -f4)"
    fi
  else
    warn "Could not resolve: $tgt"
  fi
  _end

  _sec "HTTP Fingerprint"
  if _chk curl; then
    local hdrs; hdrs="$(curl -sI --max-time 8 "http://${tgt}" 2>/dev/null || true)"
    if [ -n "$hdrs" ]; then
      local srv xpb
      srv="$(echo "$hdrs" | grep -i '^Server:' | cut -d' ' -f2- | tr -d '\r\n' || true)"
      xpb="$(echo "$hdrs" | grep -i 'X-Powered-By:' | cut -d' ' -f2- | tr -d '\r\n' || true)"
      [ -n "$srv" ] && found "Server      : $srv"    || ok "Server header: hidden"
      [ -n "$xpb" ] && warn  "X-Powered-By: $xpb"   || ok "X-Powered-By: hidden"
    else
      warn "No HTTP response (server may be down or HTTPS-only)"
    fi
  else
    warn "curl not installed"
  fi
  _end

  _sec "Common Path Probe"
  if _chk curl; then
    for p in robots.txt sitemap.xml security.txt .well-known/security.txt; do
      local c; c="$(curl -so /dev/null -w "%{http_code}" --max-time 5 "http://${tgt}/${p}" 2>/dev/null || echo '000')"
      [ "$c" = "200" ] && found "[${c}] /${p}" || echo -e "  ${DIM}|  [${c}] /${p}${R}"
    done
  fi
  _end

  audit "recon done $tgt"
}

# ============================================================
#  MODULE: PORT SCANNER
# ============================================================
mod_portscan() {
  local tgt="${1:-}" rng="${2:-1-1024}"
  [ -z "$tgt" ] && { err "Usage: cyberforge.sh portscan <host> [range]"; return 1; }
  tgt="${tgt#http://}"; tgt="${tgt#https://}"; tgt="${tgt%%/*}"

  _hdr "  PORT SCANNER: ${tgt}  [${rng}]"
  audit "portscan $tgt $rng"

  local sp ep
  sp="$(echo "$rng" | cut -d'-' -f1)"
  ep="$(echo "$rng" | cut -d'-' -f2)"

  if _chk nmap; then
    _sec "Nmap Scan"
    info "nmap -sV -p${rng} --open ${tgt}"
    echo
    nmap -sV -p"${rng}" --open -T4 "$tgt" 2>/dev/null \
      | grep -E 'PORT|open|Nmap scan' \
      | while IFS= read -r l; do
          echo "$l" | grep -q 'open' \
            && echo -e "  ${BGRN}${l}${R}" \
            || echo -e "  ${DIM}${l}${R}"
        done
    _end
  else
    _sec "Bash TCP Port Scanner (fallback)"
    warn "nmap not found -- using /dev/tcp scanner"
    echo

    _svc() {
      case "$1" in
        21) echo FTP;; 22) echo SSH;; 23) echo Telnet;; 25) echo SMTP;;
        53) echo DNS;; 80) echo HTTP;; 110) echo POP3;; 143) echo IMAP;;
        443) echo HTTPS;; 445) echo SMB;; 3306) echo MySQL;; 3389) echo RDP;;
        5432) echo PostgreSQL;; 6379) echo Redis;; 8080) echo HTTP-Alt;;
        8443) echo HTTPS-Alt;; 27017) echo MongoDB;; 5900) echo VNC;;
        9200) echo Elasticsearch;; *) echo unknown;;
      esac
    }

    local open=0 scanned=0
    local total=$(( ep - sp + 1 ))
    local port=$sp

    while [ $port -le $ep ]; do
      scanned=$(( scanned + 1 ))
      if (echo >/dev/tcp/"$tgt"/"$port") 2>/dev/null; then
        found "Port ${port}/tcp  OPEN  [$(_svc $port)]"
        open=$(( open + 1 ))
      fi
      if [ $(( scanned % 100 )) -eq 0 ]; then
        local pct=$(( scanned * 100 / total ))
        printf "\r  [>>] %d/%d (%d%%) open=%d   " "$scanned" "$total" "$pct" "$open"
      fi
      port=$(( port + 1 ))
    done
    printf "\r%-80s\r" " "
    echo
    [ $open -eq 0 ] && info "No open ports in range $rng" || found "Open: $open port(s)"
    _end
  fi

  audit "portscan done $tgt"
}

# ============================================================
#  MODULE: SSL/TLS
# ============================================================
mod_sslenum() {
  local tgt="${1:-}" port="${2:-443}"
  [ -z "$tgt" ] && { err "Usage: cyberforge.sh sslenum <host> [port]"; return 1; }
  tgt="${tgt#https://}"; tgt="${tgt#http://}"; tgt="${tgt%%/*}"

  _hdr "  SSL/TLS ANALYSIS: ${tgt}:${port}"
  audit "sslenum $tgt $port"
  _need openssl || return 1

  _sec "Certificate"
  local raw; raw="$(echo | openssl s_client -connect "${tgt}:${port}" -servername "$tgt" 2>/dev/null)"
  if [ -n "$raw" ]; then
    local ct; ct="$(echo "$raw" | openssl x509 -noout -subject -issuer -dates -fingerprint 2>/dev/null || true)"
    echo "$ct" | while IFS= read -r l; do
      local k="${l%%=*}" v="${l#*=}"
      case "$k" in
        subject*|Subject*)  found "Subject : $v" ;;
        issuer*|Issuer*)    info  "Issuer  : $v" ;;
        notBefore*)         info  "From    : $v" ;;
        notAfter*)
          local days="N/A"
          if _chk date; then
            local ep np
            ep="$(date -d "$v" +%s 2>/dev/null || date -j -f '%b %d %T %Y %Z' "$v" +%s 2>/dev/null || echo 0)"
            np="$(date +%s 2>/dev/null || echo 0)"
            [ "$ep" -gt 0 ] && [ "$np" -gt 0 ] && days=$(( (ep - np) / 86400 ))
          fi
          [ "$days" != "N/A" ] && [ "$days" -lt 30 ] \
            && warn "Expires: $v  ** ${days} DAYS LEFT **" \
            || ok   "Expires: $v  (${days} days)"
          ;;
        *Fingerprint*) info "Fingerprint: $v" ;;
      esac
    done
  else
    warn "Could not connect to ${tgt}:${port}"
  fi
  _end

  _sec "Protocol Support"
  for proto in ssl2 ssl3 tls1 tls1_1 tls1_2 tls1_3; do
    local r; r="$(echo | timeout 4 openssl s_client -"$proto" -connect "${tgt}:${port}" -servername "$tgt" 2>&1 | head -3 || true)"
    if echo "$r" | grep -q "CONNECTED"; then
      case "$proto" in
        ssl2|ssl3|tls1|tls1_1) warn "${proto^^}: ENABLED  <-- INSECURE" ;;
        *) ok "${proto^^}: ENABLED" ;;
      esac
    else
      echo -e "  ${DIM}|${R}  ${DIM}${proto^^}: Not supported${R}"
    fi
  done
  _end

  _sec "Weak Ciphers"
  for c in RC4 DES NULL EXPORT; do
    local r; r="$(echo | timeout 4 openssl s_client -cipher "$c" -connect "${tgt}:${port}" -servername "$tgt" 2>&1 | head -3 || true)"
    echo "$r" | grep -q "CONNECTED" \
      && warn "${c}: ACCEPTED  <-- VULNERABLE" \
      || ok   "${c}: Rejected"
  done
  _end

  audit "sslenum done $tgt:$port"
}

# ============================================================
#  MODULE: DNS RECON
# ============================================================
mod_dnsrecon() {
  local tgt="${1:-}"
  [ -z "$tgt" ] && { err "Usage: cyberforge.sh dnsrecon <domain>"; return 1; }
  tgt="${tgt#http://}"; tgt="${tgt#https://}"; tgt="${tgt%%/*}"

  _hdr "  DNS RECONNAISSANCE: ${tgt}"
  audit "dnsrecon $tgt"

  local tool=""
  _chk dig      && tool="dig"
  _chk nslookup && [ -z "$tool" ] && tool="nslookup"
  [ -z "$tool" ] && { warn "Need dig or nslookup"; return 1; }

  _lookup() {
    local rt="$1" d="$2"
    if [ "$tool" = "dig" ]; then
      dig +short "$rt" "$d" 2>/dev/null || true
    else
      nslookup -type="$rt" "$d" 2>/dev/null | awk '/^[^;]/{print $NF}' | grep -v '#' || true
    fi
  }

  _sec "DNS Records"
  for rt in A AAAA MX NS TXT CNAME SOA; do
    local r; r="$(_lookup "$rt" "$tgt")"
    if [ -n "$r" ]; then
      found "[$rt]"
      echo "$r" | while IFS= read -r l; do echo -e "  ${DIM}|${R}    ${CYN}${l}${R}"; done
    else
      echo -e "  ${DIM}|${R}  ${DIM}[${rt}] No records${R}"
    fi
  done
  _end

  _sec "Zone Transfer (AXFR)"
  if [ "$tool" = "dig" ]; then
    local ns; ns="$(dig +short NS "$tgt" 2>/dev/null || true)"
    if [ -n "$ns" ]; then
      echo "$ns" | while IFS= read -r n; do
        step "AXFR from: $n"
        local ax; ax="$(dig AXFR "$tgt" @"$n" 2>/dev/null | grep -v '^;' | head -20 || true)"
        [ -n "$ax" ] \
          && { warn "ZONE TRANSFER SUCCESS from $n -- MISCONFIGURATION!"; echo "$ax" | while IFS= read -r l; do attack "  $l"; done; } \
          || ok "AXFR refused from $n"
      done
    else
      info "No NS records found"
    fi
  else
    info "AXFR requires dig"
  fi
  _end

  _sec "Common Subdomain Check"
  local subs="www mail ftp dev api admin portal vpn remote webmail smtp pop ns1 ns2 cdn static media blog shop test staging beta auth sso app dashboard docs wiki git"
  local fc=0
  for sub in $subs; do
    local full="${sub}.${tgt}" ip=""
    [ "$tool" = "dig" ] && ip="$(dig +short A "$full" 2>/dev/null | head -1 || true)" \
                        || ip="$(nslookup "$full" 2>/dev/null | awk '/Address:/{print $2}' | grep -v '#' | head -1 || true)"
    if [ -n "$ip" ]; then
      found "FOUND: ${full}  ->  ${ip}"
      fc=$(( fc + 1 ))
    fi
  done
  [ $fc -eq 0 ] && info "No common subdomains found"
  _end

  audit "dnsrecon done $tgt"
}

# ============================================================
#  MODULE: WEB AUDIT
# ============================================================
mod_webaudit() {
  local url="${1:-}"
  [ -z "$url" ] && { err "Usage: cyberforge.sh webaudit <https://target.com>"; return 1; }
  [[ "$url" != http* ]] && url="http://${url}"

  _hdr "  WEB APPLICATION AUDIT: ${url}"
  audit "webaudit $url"
  _need curl || return 1

  local hdrs; hdrs="$(curl -sI --max-time 10 "$url" 2>/dev/null || true)"
  if [ -z "$hdrs" ]; then
    warn "No response from $url"
    return 0
  fi

  _sec "Security Headers"
  _chkh() {
    local h="$1" d="$2"
    if echo "$hdrs" | grep -qi "^${h}:"; then
      local v; v="$(echo "$hdrs" | grep -i "^${h}:" | cut -d':' -f2- | tr -d '\r\n' | cut -c1-60 | xargs)"
      ok "${d}: ${v}"
    else
      warn "MISSING: ${h}  [${d}]"
    fi
  }
  _chkh "Strict-Transport-Security" "HSTS"
  _chkh "Content-Security-Policy"   "CSP"
  _chkh "X-Frame-Options"           "Clickjacking Protection"
  _chkh "X-Content-Type-Options"    "MIME Sniffing Protection"
  _chkh "X-XSS-Protection"          "XSS Filter"
  _chkh "Referrer-Policy"           "Referrer Policy"
  _chkh "Permissions-Policy"        "Permissions Policy"
  _end

  _sec "Information Disclosure"
  local srv xpb
  srv="$(echo "$hdrs" | grep -i '^Server:'      | cut -d' ' -f2- | tr -d '\r\n' | xargs || true)"
  xpb="$(echo "$hdrs" | grep -i 'X-Powered-By:' | cut -d' ' -f2- | tr -d '\r\n' | xargs || true)"
  [ -n "$srv" ] && warn "Server     : $srv"   || ok "Server header: hidden"
  [ -n "$xpb" ] && warn "Backend    : $xpb"   || ok "X-Powered-By: hidden"
  _end

  _sec "Sensitive Path Discovery"
  for p in .git/HEAD .env .htaccess .htpasswd wp-login.php admin/ phpmyadmin/ phpinfo.php config.php backup.sql robots.txt swagger.json server-status security.txt; do
    local c; c="$(curl -so /dev/null -w "%{http_code}" --max-time 5 "${url}/${p}" 2>/dev/null || echo '000')"
    case "$c" in
      200)      found "[${c}] FOUND: /${p}  <-- REVIEW" ;;
      301|302)  info  "[${c}] Redirect: /${p}" ;;
      403)      echo -e "  ${DIM}|${R}  ${BYLW}[${c}] Forbidden: /${p}${R}" ;;
      *)        echo -e "  ${DIM}|${R}  ${DIM}[${c}] /${p}${R}" ;;
    esac
  done
  _end

  _sec "Cookie Security"
  local cks; cks="$(echo "$hdrs" | grep -i 'set-cookie' || true)"
  if [ -n "$cks" ]; then
    echo "$cks" | while IFS= read -r ck; do
      local cn; cn="$(echo "$ck" | cut -d'=' -f1 | awk '{print $NF}')"
      echo -e "  ${DIM}|${R}  ${BOLD}Cookie: ${cn}${R}"
      echo "$ck" | grep -qi 'httponly' && ok "  HttpOnly: Yes" || warn "  HttpOnly: MISSING"
      echo "$ck" | grep -qi 'secure'   && ok "  Secure  : Yes" || warn "  Secure  : MISSING"
      echo "$ck" | grep -qi 'samesite' && ok "  SameSite: Set" || warn "  SameSite: MISSING"
    done
  else
    info "No Set-Cookie in initial response"
  fi
  _end

  audit "webaudit done $url"
}

# ============================================================
#  MODULE: VULN SCAN
# ============================================================
mod_vulnscan() {
  local tgt="${1:-}"
  [ -z "$tgt" ] && { err "Usage: cyberforge.sh vulnscan <host>"; return 1; }
  tgt="${tgt#http://}"; tgt="${tgt#https://}"; tgt="${tgt%%/*}"

  _hdr "  VULNERABILITY SCAN: ${tgt}"
  audit "vulnscan $tgt"

  _sec "Exposed Services Check"
  for entry in "21:FTP" "22:SSH" "23:TELNET" "3306:MySQL" "5432:PostgreSQL" "6379:Redis" "27017:MongoDB" "9200:Elasticsearch"; do
    local port="${entry%%:*}" svc="${entry##*:}"
    if (echo >/dev/tcp/"$tgt"/"$port") 2>/dev/null; then
      warn "Port ${port} (${svc}): OPEN -- check default creds!"
      case "$svc" in
        Redis)         attack "redis-cli -h ${tgt} ping" ;;
        Elasticsearch) attack "curl http://${tgt}:9200/" ;;
        MongoDB)       attack "mongo ${tgt}:27017" ;;
        TELNET)        attack "Telnet is insecure -- DISABLE IT" ;;
      esac
    else
      ok "${svc} port ${port}: Closed"
    fi
  done
  _end

  _sec "Web Misconfiguration"
  if _chk curl; then
    local c b
    c="$(curl -so /dev/null -w "%{http_code}" --max-time 5 "http://${tgt}/.git/HEAD" 2>/dev/null || echo '000')"
    [ "$c" = "200" ] && warn ".git EXPOSED -- source code leak!" || ok ".git not exposed"

    b="$(curl -s --max-time 5 "http://${tgt}/" 2>/dev/null || true)"
    echo "$b" | grep -qi "Index of" && warn "Directory listing ENABLED" || ok "Directory listing: not detected"

    local xpb; xpb="$(curl -sI --max-time 5 "http://${tgt}" 2>/dev/null | grep -i 'X-Powered-By:' | tr -d '\r' || true)"
    [ -n "$xpb" ] && warn "Version exposed: $xpb"
  fi
  _end

  audit "vulnscan done $tgt"
}

# ============================================================
#  MODULE: HASH CRACK
# ============================================================
mod_hashcrack() {
  local ht="${1:-auto}" hv="${2:-}"
  [ -z "$hv" ] && { err "Usage: cyberforge.sh hashcrack <type|auto> <hash>"; return 1; }

  _hdr "  HASH IDENTIFIER & CRACKER"
  audit "hashcrack $ht"

  _sec "Hash Identification"
  local len="${#hv}" det="Unknown"
  if [ "$ht" = "auto" ]; then
    case "$len" in
      32)  det="MD5 / NTLM" ;;
      40)  det="SHA-1" ;;
      64)  det="SHA-256" ;;
      96)  det="SHA-384" ;;
      128) det="SHA-512" ;;
      *)
        echo "$hv" | grep -qE '^\$2[aby]\$' && det="bcrypt"
        echo "$hv" | grep -qE '^\$6\$'       && det="SHA-512-crypt"
        ;;
    esac
    ht="$det"
  fi
  found "Hash     : ${hv:0:48}..."
  found "Detected : ${ht}  (length ${len})"
  _end

  _sec "Dictionary Attack"
  local wl="${CF_WL}/rockyou_mini.txt"
  local words="password 123456 password123 admin letmein qwerty monkey dragon master 111111 abc123 iloveyou sunshine princess welcome shadow login pass test root toor admin123 changeme 12345678 password1 secret P@ssw0rd Password1 Pass@123 Admin@123 Summer2024 Winter2024 Hello@123"
  if [ -f "$wl" ]; then
    info "Wordlist: $wl"
    words="$(cat "$wl")"
  else
    info "Built-in list (put rockyou_mini.txt in ~/.cyberforge/wordlists/ for more)"
  fi

  local cracked=false tested=0
  for w in $words; do
    tested=$(( tested + 1 ))
    local comp=""
    case "${ht,,}" in
      *md5*)    comp="$(echo -n "$w" | md5sum    2>/dev/null | cut -d' ' -f1 || true)" ;;
      *sha-1*|*sha1*) comp="$(echo -n "$w" | sha1sum   2>/dev/null | cut -d' ' -f1 || true)" ;;
      *sha-256*|*sha256*) comp="$(echo -n "$w" | sha256sum 2>/dev/null | cut -d' ' -f1 || true)" ;;
      *sha-512*|*sha512*) comp="$(echo -n "$w" | sha512sum 2>/dev/null | cut -d' ' -f1 || true)" ;;
    esac
    if [ -n "$comp" ] && [ "${comp,,}" = "${hv,,}" ]; then
      echo
      found "CRACKED!  -->  ${BOLD}${w}${R}"
      cracked=true
      break
    fi
  done
  $cracked || { warn "Not found (tested $tested passwords)"; info "Try: hashcat / john with rockyou.txt"; }
  _end

  audit "hashcrack done cracked=$cracked"
}

# ============================================================
#  MODULE: PASS GEN
# ============================================================
mod_passgen() {
  local len="${1:-24}" mode="${2:-special}"
  _hdr "  SECURE PASSWORD GENERATOR"

  local cs
  case "$mode" in
    alpha)    cs='A-Za-z' ;;
    alnum)    cs='A-Za-z0-9' ;;
    special)  cs='A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?' ;;
    paranoid) cs='A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?~`' ;;
    *)        cs='A-Za-z0-9!@#$%^&*()_+-=' ;;
  esac

  _sec "Passwords  [length=${len}, mode=${mode}]"
  echo
  local i=1
  while [ $i -le 10 ]; do
    local p; p="$(LC_ALL=C tr -dc "$cs" < /dev/urandom 2>/dev/null | head -c "$len" || true)"
    [ -z "$p" ] && p="$(cat /dev/urandom | tr -dc "$cs" | head -c "$len" 2>/dev/null || echo 'ERR')"

    local sc=0
    echo "$p" | grep -q '[A-Z]'       && sc=$(( sc + 20 ))
    echo "$p" | grep -q '[a-z]'       && sc=$(( sc + 20 ))
    echo "$p" | grep -q '[0-9]'       && sc=$(( sc + 20 ))
    echo "$p" | grep -q '[^A-Za-z0-9]' && sc=$(( sc + 20 ))
    [ ${#p} -ge 16 ]                  && sc=$(( sc + 20 ))

    local lbl
    if   [ $sc -ge 100 ]; then lbl="${BGRN}[ULTRA-STRONG]${R}"
    elif [ $sc -ge 80  ]; then lbl="${GRN}[STRONG]${R}"
    elif [ $sc -ge 60  ]; then lbl="${BYLW}[MEDIUM]${R}"
    else                       lbl="${BRED}[WEAK]${R}"
    fi
    printf "  ${DIM}|${R}  ${BOLD}%2d.${R} ${BCYN}%s${R}  %b\n" "$i" "$p" "$lbl"
    i=$(( i + 1 ))
  done
  echo
  _end
  _sec "Info"
  _row "Length" "${len} chars"   "$BCYN"
  _row "Mode"   "$mode"          "$CYN"
  _row "Source" "/dev/urandom"   "$BGRN"
  _end
}

# ============================================================
#  MODULE: ENCODE / DECODE
# ============================================================
mod_encodedec() {
  local act="${1:-}" sch="${2:-}" inp="${3:-}"
  [ -z "$inp" ] && { err "Usage: cyberforge.sh encodedec <encode|decode> <scheme> <text>"; return 1; }

  _hdr "  ENCODE / DECODE"
  _sec "${act^^}: ${sch^^}"
  local out=""
  case "${sch,,}" in
    base64)
      [ "$act" = "encode" ] \
        && out="$(echo -n "$inp" | base64 2>/dev/null | tr -d '\n')" \
        || out="$(echo "$inp"   | base64 -d 2>/dev/null || echo '[invalid]')"
      ;;
    hex)
      if _chk xxd; then
        [ "$act" = "encode" ] \
          && out="$(echo -n "$inp" | xxd -p | tr -d '\n')" \
          || out="$(echo "$inp" | xxd -r -p 2>/dev/null || echo '[invalid]')"
      else
        # Pure bash hex encode
        if [ "$act" = "encode" ]; then
          local r="" i=0
          while [ $i -lt ${#inp} ]; do
            r="${r}$(printf '%02x' "'${inp:$i:1}" 2>/dev/null || echo '??')"
            i=$(( i + 1 ))
          done
          out="$r"
        else
          out="[xxd not available]"
        fi
      fi
      ;;
    url)
      if _chk python3; then
        [ "$act" = "encode" ] \
          && out="$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$inp" 2>/dev/null)" \
          || out="$(python3 -c "import urllib.parse,sys;print(urllib.parse.unquote(sys.argv[1]))" "$inp" 2>/dev/null)"
      else
        out="${inp// /%20}"
        warn "python3 not found -- only spaces encoded"
      fi
      ;;
    rot13)  out="$(echo "$inp" | tr 'A-Za-z' 'N-ZA-Mn-za-m')" ;;
    md5)    out="$(echo -n "$inp" | md5sum    2>/dev/null | cut -d' ' -f1 || echo N/A)" ;;
    sha1)   out="$(echo -n "$inp" | sha1sum   2>/dev/null | cut -d' ' -f1 || echo N/A)" ;;
    sha256) out="$(echo -n "$inp" | sha256sum 2>/dev/null | cut -d' ' -f1 || echo N/A)" ;;
    sha512) out="$(echo -n "$inp" | sha512sum 2>/dev/null | cut -d' ' -f1 || echo N/A)" ;;
    *)
      err "Unknown: $sch"
      info "Schemes: base64 hex url rot13 md5 sha1 sha256 sha512"
      return 1
      ;;
  esac
  echo
  found "Input  : $inp"
  found "Output : ${BOLD}${out}${R}"
  echo
  _end
}

# ============================================================
#  MODULE: SYSTEM INFO
# ============================================================
mod_sysinfo() {
  _hdr "  SYSTEM FINGERPRINT"
  linfo "sysinfo"

  _sec "Operating System"
  _row "OS"           "$(uname -s 2>/dev/null || echo N/A)"   "$BCYN"
  _row "Kernel"       "$(uname -r 2>/dev/null || echo N/A)"   "$CYN"
  _row "Architecture" "$(uname -m 2>/dev/null || echo N/A)"   "$CYN"
  _row "Hostname"     "$(hostname  2>/dev/null || echo N/A)"  "$BYLW"
  _row "Platform"     "$_OS"                                   "$DIM"

  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    local dn; dn="$(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-${NAME:-?}}")"
    _row "Distribution" "$dn" "$BGRN"
  fi
  if $_IS_MAC; then
    _row "macOS" "$(sw_vers -productVersion 2>/dev/null || echo N/A)" "$BGRN"
  fi

  local up="N/A"
  _chk uptime && up="$(uptime 2>/dev/null | sed 's/.*up //' | cut -d',' -f1 | xargs || echo N/A)"
  _row "Uptime" "$up" "$DIM"
  _end

  _sec "CPU"
  local cm="N/A" cc="N/A" mhz="N/A" la="N/A"
  if [ -f /proc/cpuinfo ]; then
    cm="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d':' -f2 | xargs || echo N/A)"
    cc="$(grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo N/A)"
    mhz="$(grep 'cpu MHz' /proc/cpuinfo 2>/dev/null | head -1 | awk '{print $4}' || echo N/A)"
  elif $_IS_MAC; then
    cm="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo N/A)"
    cc="$(sysctl -n hw.physicalcpu 2>/dev/null || echo N/A)"
  fi
  [ -f /proc/loadavg ] && la="$(awk '{print $1,$2,$3}' /proc/loadavg 2>/dev/null || echo N/A)"
  _row "Model"           "$cm"       "$BCYN"
  _row "Cores"           "$cc"       "$CYN"
  _row "Frequency"       "${mhz} MHz" "$DIM"
  _row "Load (1/5/15m)"  "$la"       "$BYLW"
  _end

  _sec "Memory"
  local mt="N/A" mu="N/A" ma="N/A" pct=0
  if [ -f /proc/meminfo ]; then
    local tk ak uk
    tk="$(awk '/MemTotal/{print $2}'     /proc/meminfo 2>/dev/null || echo 0)"
    ak="$(awk '/MemAvailable/{print $2}' /proc/meminfo 2>/dev/null || echo 0)"
    uk=$(( tk - ak ))
    mt="$(( tk / 1024 )) MB"
    ma="$(( ak / 1024 )) MB"
    mu="$(( uk / 1024 )) MB"
    [ $tk -gt 0 ] && pct=$(( uk * 100 / tk ))
  elif $_IS_MAC && _chk vm_stat; then
    mt="$(sysctl -n hw.memsize 2>/dev/null | awk '{print int($1/1024/1024)" MB"}' || echo N/A)"
  fi
  local bf=$(( pct * 28 / 100 )) be=$(( 28 - pct * 28 / 100 ))
  _row "Total"     "$mt"                   "$CYN"
  _row "Used"      "$mu"                   "$BYLW"
  _row "Available" "$ma"                   "$BGRN"
  printf "  ${DIM}|${R}  ${BOLD}%-28s${R} ${BCYN}%s${R} ${DIM}%d%%${R}\n" \
    "Usage Bar" "$(_bar $bf $be)" "$pct"
  _end

  _sec "Network Interfaces"
  if _chk ip; then
    ip addr show 2>/dev/null | awk '/^[0-9]+:/{i=$2} /inet /{print i, $2}' | grep -v '^lo ' \
      | while read -r i a; do _row "${i%%:}" "$a" "$BCYN"; done
  elif _chk ifconfig; then
    ifconfig 2>/dev/null | awk '/^[a-z]/{i=$1} /inet /{print i, $2}' | grep -v 'lo\|127' \
      | while read -r i a; do _row "${i%%:}" "${a#addr:}" "$BCYN"; done
  elif _chk ipconfig; then
    ipconfig 2>/dev/null | grep -E 'IPv4' | awk '{print $NF}' \
      | while IFS= read -r a; do _row "Interface" "$a" "$BCYN"; done
  else
    info "No network tool (ip / ifconfig / ipconfig)"
  fi
  _end

  _sec "Logged-in Users"
  if _chk who; then
    who 2>/dev/null | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}$l${R}"; done \
      || info "No users or who unavailable"
  else
    info "who not available"
  fi
  _end

  linfo "sysinfo done"
}

# ============================================================
#  MODULE: PROCESS MONITOR
# ============================================================
mod_procmon() {
  _hdr "  PROCESS MONITOR"
  linfo "procmon"

  _sec "Top CPU Consumers"
  if _chk ps; then
    printf "  ${DIM}|${R}  ${BOLD}%-8s %-25s %8s %8s${R}\n" "PID" "Process" "CPU%" "MEM%"
    echo -e "  ${DIM}|${R}  $(_rep '-' 54)"
    ps aux --sort=-%cpu 2>/dev/null \
      | awk 'NR>1&&NR<=16{printf "  \033[2m|\033[0m  %-8s %-25s %8s %8s\n",$2,$11,$3,$4}' \
      | head -15
  else
    info "ps not available"
  fi
  _end

  _sec "Network Connections"
  if _chk ss; then
    ss -tulnp 2>/dev/null | head -20 | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
  elif _chk netstat; then
    netstat -an 2>/dev/null | grep -E 'LISTEN|ESTABLISHED' | head -20 \
      | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
  else
    info "ss / netstat not available"
  fi
  _end
}

# ============================================================
#  MODULE: CODE AUDIT
# ============================================================
mod_codeaudit() {
  local path="${1:-$(pwd)}"
  [ ! -d "$path" ] && { err "Directory not found: $path"; return 1; }

  _hdr "  CODE AUDIT: ${path}"
  audit "codeaudit $path"

  _sec "Secret / Credential Patterns"
  local hits=0
  for pat in "password=" "passwd=" "secret=" "api_key=" "apikey=" "access_token=" "private_key=" "BEGIN.RSA.PRIVATE" "AKIA[0-9A-Z]" "ghp_" "glpat-" "mysql://" "postgresql://" "mongodb://"; do
    local m
    m="$(grep -rEi --include='*.py' --include='*.js' --include='*.ts' \
         --include='*.php' --include='*.rb' --include='*.java' \
         --include='*.go' --include='*.env' --include='*.yml' \
         --include='*.yaml' --include='*.json' --include='*.sh' \
         -l "$pat" "$path" 2>/dev/null | head -5 || true)"
    if [ -n "$m" ]; then
      warn "Pattern: ${pat}"
      echo "$m" | while IFS= read -r f; do attack "  --> $f"; done
      hits=$(( hits + 1 ))
    fi
  done
  [ $hits -eq 0 ] && ok "No obvious secrets found"
  _end

  _sec "Code Debt"
  local td fx hk
  td="$(grep -r --include='*.py' --include='*.js' --include='*.ts' --include='*.go' --include='*.java' -ic 'TODO'  "$path" 2>/dev/null | awk -F: 'NF==2{s+=$2}END{print s+0}' || echo 0)"
  fx="$(grep -r --include='*.py' --include='*.js' --include='*.ts' --include='*.go' --include='*.java' -ic 'FIXME' "$path" 2>/dev/null | awk -F: 'NF==2{s+=$2}END{print s+0}' || echo 0)"
  hk="$(grep -r --include='*.py' --include='*.js' --include='*.ts' --include='*.go' --include='*.java' -icE 'HACK|XXX' "$path" 2>/dev/null | awk -F: 'NF==2{s+=$2}END{print s+0}' || echo 0)"
  _row "TODOs"  "$td" "$BYLW"
  _row "FIXMEs" "$fx" "$BRED"
  _row "HACKs"  "$hk" "$BRED"
  _end

  _sec "File Statistics"
  find "$path" -type f -not -path '*/.git/*' -not -path '*/node_modules/*' -not -path '*/__pycache__/*' 2>/dev/null \
    | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -15 \
    | while read -r cnt ext; do
        printf "  ${DIM}|${R}  ${BOLD}%-15s${R} ${CYN}%d files${R}\n" ".${ext}" "$cnt"
      done
  _end

  audit "codeaudit done $path"
}

# ============================================================
#  MODULE: SSH AUDIT
# ============================================================
mod_sshaudit() {
  _hdr "  SSH AUDIT"
  audit "sshaudit"

  _sec "sshd_config"
  local cf="/etc/ssh/sshd_config"
  if [ -f "$cf" ]; then
    _chks() {
      local k="$1" ideal="$2" sev="$3"
      local v; v="$(grep -i "^${k}" "$cf" 2>/dev/null | awk '{print $2}' | head -1 || true)"
      if [ -z "$v" ]; then
        echo -e "  ${DIM}|${R}  ${DIM}[${sev}] ${k}: default${R}"
      elif echo "$v" | grep -qi "^${ideal}$"; then
        ok "[${sev}] ${k} = ${v}"
      else
        warn "[${sev}] ${k} = ${v}  (recommend: ${ideal})"
      fi
    }
    _chks "PermitRootLogin"        "no" "CRITICAL"
    _chks "PasswordAuthentication" "no" "HIGH"
    _chks "PermitEmptyPasswords"   "no" "CRITICAL"
    _chks "X11Forwarding"          "no" "LOW"
    _chks "MaxAuthTries"           "3"  "MEDIUM"
  else
    $_IS_WIN && info "sshd_config not expected on Windows Git Bash" || info "Not found (may need sudo)"
  fi
  _end

  _sec "SSH Keys"
  local sd="${HOME}/.ssh"
  if [ -d "$sd" ]; then
    for kf in "${sd}"/id_*; do
      [ -f "$kf" ] || continue
      echo "$kf" | grep -q '\.pub$' && continue
      found "Key: $kf"
      local perms
      perms="$(stat -c '%a' "$kf" 2>/dev/null || stat -f '%A' "$kf" 2>/dev/null || echo N/A)"
      if [ "$perms" != "600" ] && [ "$perms" != "N/A" ]; then
        warn "  Perms: ${perms}  (should be 600)"
        info "  Fix:   chmod 600 $kf"
      else
        ok "  Perms: ${perms}"
      fi
    done
  else
    info "No ~/.ssh directory"
  fi
  _end
}

# ============================================================
#  MODULE: GIT CHECK
# ============================================================
mod_gitcheck() {
  _hdr "  GIT SECURITY SCANNER"
  audit "gitcheck"

  if ! _chk git; then err "git not installed"; return 1; fi
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then err "Not in a git repo"; return 1; fi

  _sec "Secrets in Git History"
  warn "Scanning all commits..."
  local hits=0
  for pat in "password=" "api_key=" "secret=" "access_token=" "private_key=" "BEGIN.RSA.PRIVATE" "AKIA" "ghp_" "glpat-"; do
    local c; c="$(git log --all --oneline -S "$pat" 2>/dev/null | head -5 || true)"
    if [ -n "$c" ]; then
      warn "Pattern '${pat}' in commits:"
      echo "$c" | while IFS= read -r l; do attack "  $l"; done
      hits=$(( hits + 1 ))
    fi
  done
  [ $hits -eq 0 ] && ok "No secrets found in history"
  _end

  _sec ".gitignore Coverage"
  local root gi
  root="$(git rev-parse --show-toplevel 2>/dev/null || echo '.')"
  gi="${root}/.gitignore"
  if [ -f "$gi" ]; then
    for e in ".env" "*.pem" "*.key" "id_rsa" "node_modules/" "__pycache__/" ".DS_Store" "*.log" "dist/" "build/"; do
      grep -qF "$e" "$gi" 2>/dev/null && ok "Covered: $e" || warn "Missing: $e"
    done
  else
    err ".gitignore missing -- create one!"
  fi
  _end
}

# ============================================================
#  MODULE: NETWORK MONITOR
# ============================================================
mod_netmon() {
  _hdr "  NETWORK MONITOR"
  linfo "netmon"

  _sec "Listening Ports"
  if _chk ss; then
    ss -tulnp 2>/dev/null | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
  elif _chk netstat; then
    netstat -an 2>/dev/null | grep -E 'LISTEN|UDP' | head -20 | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
  elif $_IS_WIN && _chk netstat.exe; then
    netstat.exe -an 2>/dev/null | grep LISTENING | head -20 | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
  else
    info "No network tool (ss / netstat)"
  fi
  _end

  _sec "Established Connections"
  if _chk ss; then
    ss -tnp state established 2>/dev/null | head -20 | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${GRN}${l}${R}"; done
  elif _chk netstat; then
    netstat -an 2>/dev/null | grep ESTABLISHED | head -20 | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${GRN}${l}${R}"; done
  fi
  _end
}

# ============================================================
#  MODULE: LOG AUDIT
# ============================================================
mod_logaudit() {
  _hdr "  LOG FORENSICS"
  linfo "logaudit"

  _sec "Auth Failures"
  local al=""
  for f in /var/log/auth.log /var/log/secure; do [ -f "$f" ] && { al="$f"; break; }; done
  if [ -n "$al" ]; then
    local fc; fc="$(grep -c 'Failed password\|Invalid user\|authentication failure' "$al" 2>/dev/null || echo 0)"
    [ "$fc" -gt 10 ] && warn "High failures: $fc" || ok "Auth failures: $fc"
    grep 'Failed password\|Invalid user' "$al" 2>/dev/null | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head -10 \
      | while read -r cnt ip; do [ $cnt -gt 5 ] && warn "$cnt from $ip" || info "$cnt from $ip"; done
  else
    $_IS_WIN && info "Auth logs not in Git Bash -- use Event Viewer" || info "Log not accessible (try sudo)"
  fi
  _end

  _sec "CyberForge Audit Trail"
  if [ -f "$CF_LOG" ]; then
    grep '\[AUDIT\]' "$CF_LOG" 2>/dev/null | tail -20 | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
  else
    info "No audit log yet"
  fi
  _end
}

# ============================================================
#  MODULE: FIREWALL
# ============================================================
mod_firewall() {
  _hdr "  FIREWALL AUDIT"
  audit "firewall"

  _sec "UFW"
  if _chk ufw; then
    local st; st="$(ufw status 2>/dev/null | head -20 || echo 'Permission denied')"
    echo "$st" | grep -q "active" && ok "UFW: ACTIVE" || warn "UFW: INACTIVE"
    echo "$st" | tail -n +3 | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${DIM}${l}${R}"; done
  elif $_IS_WIN; then
    info "UFW not on Windows"
    if _chk netsh; then
      netsh advfirewall show allprofiles 2>/dev/null | grep -E 'State|Firewall' \
        | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
    fi
  else
    info "UFW not installed (sudo apt install ufw)"
  fi
  _end

  _sec "iptables"
  if _chk iptables; then
    iptables -L --line-numbers 2>/dev/null | head -30 | while IFS= read -r l; do
      echo "$l" | grep -qE 'DROP|REJECT' \
        && echo -e "  ${DIM}|${R}  ${BGRN}${l}${R}" \
        || echo -e "  ${DIM}|${R}  ${DIM}${l}${R}"
    done 2>/dev/null || info "Need root for iptables"
  else
    info "iptables not available"
  fi
  _end

  _sec "Hardening Tips"
  local i=1
  for t in \
    "Default DENY all inbound -- whitelist only needed ports" \
    "Rate-limit SSH:  ufw limit ssh" \
    "Install fail2ban -- auto-ban brute-force IPs" \
    "Log dropped packets for forensics" \
    "Review firewall rules monthly" \
    "Consider nftables (modern iptables replacement)"; do
    printf "  ${DIM}|${R}  ${BBLU}%d.${R} %s\n" "$i" "$t"
    i=$(( i + 1 ))
  done
  _end
}

# ============================================================
#  MODULE: ENV CHECK
# ============================================================
mod_envcheck() {
  _hdr "  DEVELOPMENT ENVIRONMENT HEALTH"
  linfo "envcheck"

  _sec "Installed Tools"
  for cmd in git docker kubectl terraform ansible python3 node go java rustc gcc make curl wget jq nmap openssl vim tmux htop; do
    if _chk "$cmd"; then
      local v; v="$("$cmd" --version 2>&1 | head -1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1 || echo '')"
      ok "$(printf '%-20s' "$cmd")${v:+v$v}"
    else
      warn "$(printf '%-20s' "$cmd")NOT INSTALLED"
    fi
  done
  _end
}

# ============================================================
#  MODULE: API DEBUG
# ============================================================
mod_apidebug() {
  local url="${1:-}" mth="${2:-GET}" dat="${3:-}"
  [ -z "$url" ] && { err "Usage: cyberforge.sh apidebug <url> [METHOD] [body]"; return 1; }
  _need curl || return 1

  _hdr "  REST API DEBUGGER"
  linfo "apidebug $mth $url"

  _sec "Request"
  _row "URL"    "$url"  "$BCYN"
  _row "Method" "$mth"  "$BYLW"
  [ -n "$dat" ] && _row "Body" "${dat:0:60}" "$DIM"
  _end

  local rf="${CF_DIR}/resp.tmp" hf="${CF_DIR}/hdr.tmp"
  local tim
  if [ -n "$dat" ]; then
    tim="$(curl -s -w "%{time_total}" -o "$rf" -D "$hf" -X "$mth" \
          -H "Content-Type: application/json" -d "$dat" --max-time 15 "$url" 2>/dev/null || echo 0)"
  else
    tim="$(curl -s -w "%{time_total}" -o "$rf" -D "$hf" -X "$mth" --max-time 15 "$url" 2>/dev/null || echo 0)"
  fi

  local hc ct
  hc="$(head -1 "$hf" 2>/dev/null | grep -oE '[0-9]{3}' | head -1 || echo '000')"
  ct="$(grep -i 'content-type' "$hf" 2>/dev/null | cut -d':' -f2- | tr -d '\r\n' | xargs || true)"

  local cc="$DIM"
  case "${hc:0:1}" in 2) cc="$BGRN";; 3) cc="$BCYN";; 4) cc="$BYLW";; 5) cc="$BRED";; esac

  _sec "Response"
  _row "Status"       "$hc"                                   "$cc"
  _row "Content-Type" "${ct:-N/A}"                            "$CYN"
  _row "Time"         "${tim}s"                               "$BYLW"
  _row "Size"         "$(wc -c < "$rf" 2>/dev/null || echo 0)B" "$DIM"
  echo
  echo -e "  ${DIM}Preview:${R}"
  echo -e "  $(_rep '-' 70)"
  head -30 "$rf" 2>/dev/null | while IFS= read -r l; do echo -e "  ${CYN}${l}${R}"; done
  echo -e "  $(_rep '-' 70)"
  rm -f "$rf" "$hf" 2>/dev/null || true
  _end
}

# ============================================================
#  MODULE: DISK AUDIT
# ============================================================
mod_diskaudit() {
  _hdr "  DISK AUDIT"
  linfo "diskaudit"

  _sec "Partition Usage"
  df -h 2>/dev/null | grep -v tmpfs | while IFS= read -r l; do
    local p; p="$(echo "$l" | awk '{print $5}' | tr -d '%')"
    if echo "$p" | grep -qE '^[0-9]+$'; then
      if [ "$p" -gt 80 ]; then
        echo -e "  ${DIM}|${R}  ${BRED}${l}${R}  <-- HIGH"
      elif [ "$p" -gt 60 ]; then
        echo -e "  ${DIM}|${R}  ${BYLW}${l}${R}"
      else
        echo -e "  ${DIM}|${R}  ${DIM}${l}${R}"
      fi
    else
      echo -e "  ${DIM}|${R}  ${DIM}${l}${R}"
    fi
  done
  _end

  _sec "Largest Files (>50MB)"
  find / -type f -size +50M -not -path '/proc/*' -not -path '/sys/*' -not -path '/dev/*' 2>/dev/null \
    | head -10 | while IFS= read -r f; do
        local s; s="$(du -sh "$f" 2>/dev/null | cut -f1)"
        warn "${s}  ${f}"
      done
  _end
}

# ============================================================
#  MODULE: DOCKER AUDIT
# ============================================================
mod_dockeraudit() {
  _hdr "  DOCKER SECURITY AUDIT"
  audit "dockeraudit"

  if ! _chk docker; then warn "Docker not installed"; return 0; fi

  _sec "Running Containers"
  docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null \
    | while IFS= read -r l; do echo -e "  ${DIM}|${R}  ${CYN}${l}${R}"; done
  _end

  _sec "Security Check"
  docker ps -q 2>/dev/null | while IFS= read -r id; do
    local nm usr prv
    nm="$(docker inspect --format '{{.Name}}'                   "$id" 2>/dev/null | tr -d '/')"
    usr="$(docker inspect --format '{{.Config.User}}'           "$id" 2>/dev/null)"
    prv="$(docker inspect --format '{{.HostConfig.Privileged}}' "$id" 2>/dev/null)"
    [ -z "$usr" ] || [ "$usr" = "root" ] || [ "$usr" = "0" ] \
      && warn "${nm}: running as ROOT" \
      || ok   "${nm}: user=${usr}"
    [ "$prv" = "true" ] \
      && warn "${nm}: PRIVILEGED mode <-- RISK" \
      || ok   "${nm}: not privileged"
  done
  _end
}

# ============================================================
#  MODULE: REPORT
# ============================================================
mod_report() {
  local ts; ts="$(date '+%Y%m%d_%H%M%S' 2>/dev/null || echo 'report')"
  local rpt="${CF_REPORTS}/cyberforge_${ts}.txt"
  mkdir -p "$CF_REPORTS" 2>/dev/null

  info "Generating report..."
  info "Output: $rpt"
  {
    echo "================================================"
    echo " CyberForge Security Report"
    echo " Developer : Demiyan Dissanayake"
    echo " Generated : $(date 2>/dev/null)"
    echo " Host      : $(hostname 2>/dev/null)"
    echo " Platform  : ${_OS}"
    echo "================================================"
    mod_sysinfo; mod_procmon; mod_netmon
    mod_sshaudit; mod_firewall; mod_diskaudit
    mod_envcheck; mod_logaudit
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 && mod_gitcheck
  } 2>&1 | sed 's/\x1b\[[0-9;]*m//g' > "$rpt"
  ok "Report saved: $rpt"
  linfo "report $rpt"
}

# ============================================================
#  MAIN
# ============================================================
main() {
  _init
  local cmd="${1:-help}"
  shift || true
  case "$cmd" in
    recon)       mod_recon       "$@" ;;
    portscan)    mod_portscan    "$@" ;;
    vulnscan)    mod_vulnscan    "$@" ;;
    sslenum)     mod_sslenum     "$@" ;;
    dnsrecon)    mod_dnsrecon    "$@" ;;
    webaudit)    mod_webaudit    "$@" ;;
    hashcrack)   mod_hashcrack   "$@" ;;
    passgen)     mod_passgen     "$@" ;;
    encodedec)   mod_encodedec   "$@" ;;
    netmon)      mod_netmon      "$@" ;;
    logaudit)    mod_logaudit    "$@" ;;
    firewall)    mod_firewall    "$@" ;;
    sysinfo)     mod_sysinfo     "$@" ;;
    procmon)     mod_procmon     "$@" ;;
    diskaudit)   mod_diskaudit   "$@" ;;
    sshaudit)    mod_sshaudit    "$@" ;;
    codeaudit)   mod_codeaudit   "$@" ;;
    envcheck|depcheck) mod_envcheck "$@" ;;
    apidebug)    mod_apidebug   "$@" ;;
    dockeraudit) mod_dockeraudit "$@" ;;
    gitcheck)    mod_gitcheck    "$@" ;;
    report)      mod_report      "$@" ;;
    version)
      echo -e "${BRED}CyberForge${R} v${VER}"
      echo -e "Developer : ${AUTHOR}"
      echo -e "Platform  : ${_OS}"
      echo -e "GitHub    : ${GITHUB}"
      ;;
    help|--help|-h|"") _help ;;
    *) err "Unknown: $cmd"; _help; exit 1 ;;
  esac
}

main "$@"
