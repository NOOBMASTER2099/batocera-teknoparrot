#!/bin/bash
# ============================================================
# TeknoParrot Setup Script for Batocera (x86_64)
# Works on Batocera 41 / 42 / 43+
# Method: Windows/.pc + Wine (most reliable)
# ============================================================

set -e

echo "=============================================="
echo "  TeknoParrot Installer for Batocera"
echo "=============================================="
echo

# Check we're on Batocera
if [ ! -d "/userdata" ]; then
    echo "ERROR: This script must be run on Batocera."
    exit 1
fi

# Paths
ROMS_DIR="/userdata/roms/windows"
TP_DIR="$ROMS_DIR/TeknoParrot.pc"
SHARE="/userdata/system"

echo "[1/6] Creating folders..."
mkdir -p "$ROMS_DIR"
mkdir -p "$TP_DIR"
mkdir -p "$SHARE/configs/teknoparrot"
mkdir -p "/userdata/roms/teknoparrot"          # optional separate system folder
mkdir -p "/userdata/saves/teknoparrot"

echo "[2/6] Folder structure ready."
echo
echo ">>> ACTION REQUIRED <<<"
echo "1. Download the latest TeknoParrot from the official site:"
echo "   https://teknoparrot.com/  (or teknogods.github.io)"
echo
echo "2. Extract the entire TeknoParrot folder contents into:"
echo "   $TP_DIR"
echo
echo "   Final structure should look like:"
echo "   $TP_DIR/TeknoParrotUi.exe"
echo "   $TP_DIR/GameProfiles/"
echo "   $TP_DIR/Metadata/"
echo "   etc."
echo
read -p "Press ENTER after you have copied TeknoParrot files into $TP_DIR ..."

# Verify
if [ ! -f "$TP_DIR/TeknoParrotUi.exe" ]; then
    echo "ERROR: TeknoParrotUi.exe not found in $TP_DIR"
    echo "Please extract the files correctly and run the script again."
    exit 1
fi

echo
echo "[3/6] Creating base autorun.cmd (launches the UI)..."
cat > "$TP_DIR/autorun.cmd" << 'EOF'
# Launch TeknoParrot UI
CMD=TeknoParrotUi.exe
EOF

echo "[4/6] Setting permissions..."
chmod -R 755 "$TP_DIR"
chown -R root:root "$TP_DIR" 2>/dev/null || true

echo
echo "[5/6] Creating helper scripts..."

# Helper to launch a specific game profile
cat > "$SHARE/teknoparrot-launch.sh" << 'EOF'
#!/bin/bash
# Usage: teknoparrot-launch.sh ProfileName
# Example: teknoparrot-launch.sh InitialD6

PROFILE="$1"
TP="/userdata/roms/windows/TeknoParrot.pc"

if [ -z "$PROFILE" ]; then
    echo "Usage: $0 <ProfileName>"
    echo "Example: $0 InitialD6"
    exit 1
fi

# Create temporary autorun for this profile
echo "CMD=TeknoParrotUi.exe --profile=${PROFILE}.xml" > "$TP/autorun.cmd"
echo "Launching profile: $PROFILE"
EOF
chmod +x "$SHARE/teknoparrot-launch.sh"

echo "[6/6] Done."
echo
echo "=============================================="
echo "  NEXT STEPS"
echo "=============================================="
echo
echo "1. Restart EmulationStation (or reboot)"
echo "2. Go to the Windows system"
echo "3. Launch 'TeknoParrot' once"
echo "   → This creates the Wine bottle"
echo
echo "4. First run will open a Windows explorer-like window."
echo "   Install these if prompted / needed:"
echo "   - Visual C++ Redistributables (2010, 2015-2022 x86+x64)"
echo "   - .NET Framework 4.8 (or 4.6.2+)"
echo "   - DirectX End-User Runtime"
echo
echo "5. Run TeknoParrotUi.exe inside the Wine window and let it update."
echo
echo "6. After updates, exit with START+SELECT"
echo
echo "7. To launch specific games later, either:"
echo "   - Edit autorun.cmd to:"
echo "     CMD=TeknoParrotUi.exe --profile=GameName.xml"
echo "   - Or use the helper: /userdata/system/teknoparrot-launch.sh GameName"
echo
echo "Games themselves go in:"
echo "  /userdata/roms/teknoparrot/   (recommended)"
echo "  or inside the TeknoParrot.pc folder"
echo
echo "Your GTX 1060 is solid for most TeknoParrot titles."
echo "Enjoy."
echo
