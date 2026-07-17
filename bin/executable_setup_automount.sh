#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# setup_automount.sh
#
# Declaratively (re)configures macOS autofs to automount a fixed set of SMB
# shares under /Volumes/<key>, with matching symlinks under ~/SD/<key>.
#
# The SHARES array below is the single source of truth. Every run rewrites
# /etc/auto_smb from scratch, so this is idempotent and safe to re-run on any
# Mac to converge it to the same state (a timestamped backup of the previous
# /etc/auto_smb is kept alongside it).
#
# Passwords are never stored here. For each share's server, export:
#   SMB_PASS_<SERVERLABEL>=...   (server's first DNS label, uppercased,
#                                 e.g. SMB_PASS_FSERVER7 for fserver7.in.xt6.us)
# or a fallback SMB_PASS used for any server without its own SMB_PASS_<X>.
#
# Passwords are inserted verbatim into an smb:// URL, so if a password itself
# contains characters like @ : / % you must percent-encode it before
# exporting it, e.g.:
#   python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1], safe=''))" 'my@pass'
#
# Share names with spaces or special characters must already be
# percent-encoded in the SHARES array (spaces -> %20, etc).
# ---------------------------------------------------------------------------

# key|server|share(URL-encoded)|username
SHARES=(
  "fserver7_Sync|fserver7.in.xt6.us|Sync|carlos"
  "fserver7_Devel|fserver7.in.xt6.us|Devel|carlos"
  "fserver7_Home|fserver7.in.xt6.us|Home|carlos"
  "fserver7_FotosLaureanaYMarcelo|fserver7.in.xt6.us|Fotos%20Laureana%20y%20Marcelo|carlos"
)

AUTO_MASTER=/etc/auto_master
AUTO_SMB=/etc/auto_smb
SD_DIR="$HOME/SD"

server_var() {
  # fserver7.in.xt6.us -> FSERVER7
  echo "$1" | cut -d. -f1 | tr '[:lower:]-' '[:upper:]_'
}

password_for_server() {
  local server="$1" var
  var="SMB_PASS_$(server_var "$server")"
  if [[ -n "${!var:-}" ]]; then
    printf '%s' "${!var}"
  elif [[ -n "${SMB_PASS:-}" ]]; then
    printf '%s' "$SMB_PASS"
  else
    echo "Error: no password for server '$server'. Set \$$var or a fallback \$SMB_PASS." >&2
    exit 1
  fi
}

# --- Preflight: fail fast if any share is missing a password ---
for entry in "${SHARES[@]}"; do
  IFS='|' read -r key server share user <<< "$entry"
  password_for_server "$server" >/dev/null
done

# --- Build the new auto_smb content in a private temp file ---
tmp_smb=$(mktemp)
chmod 600 "$tmp_smb"
trap 'rm -f "$tmp_smb"' EXIT

for entry in "${SHARES[@]}"; do
  IFS='|' read -r key server share user <<< "$entry"
  pass=$(password_for_server "$server")
  printf '%s\t\t-fstype=smbfs,soft\t://%s:%s@%s/%s\n' "$key" "$user" "$pass" "$server" "$share" >> "$tmp_smb"
done

# --- Install auto_smb (root-only readable, backs up any previous version) ---
if [[ -f "$AUTO_SMB" ]]; then
  sudo cp "$AUTO_SMB" "${AUTO_SMB}.bak.$(date +%Y%m%d%H%M%S)"
fi
sudo cp "$tmp_smb" "$AUTO_SMB"
sudo chown root:wheel "$AUTO_SMB"
sudo chmod 600 "$AUTO_SMB"

# --- Ensure auto_master routes /Volumes through auto_smb (only once) ---
if ! grep -qE '^/Volumes[[:space:]]+auto_smb\b' "$AUTO_MASTER"; then
  echo '/Volumes		auto_smb	-nosuid' | sudo tee -a "$AUTO_MASTER" >/dev/null
fi

# --- Reload autofs ---
sudo automount -vc || echo "Warning: automount reported an issue above (often a harmless HIDDEN-flag warning on /Volumes)" >&2

# --- Symlinks + trigger each mount ---
mkdir -p "$SD_DIR"
for entry in "${SHARES[@]}"; do
  IFS='|' read -r key server share user <<< "$entry"
  ln -sf "/Volumes/$key" "$SD_DIR/$key"
  if ls "/Volumes/$key" >/dev/null 2>&1; then
    echo "OK    $key -> /Volumes/$key"
  else
    echo "WARN  $key did not mount (server unreachable from this Mac?)" >&2
  fi
done

echo "Done."
