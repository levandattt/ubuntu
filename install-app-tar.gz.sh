#!/bin/bash
# install-app.sh
# A generic installer for Linux apps distributed as .tar.gz

# RUN EXAMPLE
# chmod +x install-app.sh
# ./install-app.sh Postman-linux-x64-xxx.tar.gz Postman postman

set -e

if [ $# -lt 3 ]; then
  echo "Usage: $0 <tar.gz file> <AppName> <ExecName>"
  echo "Example: $0 Postman-linux-x64.tar.gz Postman postman"
  exit 1
fi

TAR_FILE=$1
APP_NAME=$2
EXEC_NAME=$3
INSTALL_DIR="/opt/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$EXEC_NAME.desktop"

echo ">>> Extracting $TAR_FILE..."
tar -xvzf "$TAR_FILE"

FOLDER=$(tar -tf "$TAR_FILE" | head -1 | cut -f1 -d"/")
echo ">>> Moving $FOLDER to $INSTALL_DIR..."
sudo rm -rf "$INSTALL_DIR"
sudo mv "$FOLDER" "$INSTALL_DIR"

echo ">>> Creating symlink /usr/bin/$EXEC_NAME..."
sudo ln -sf "$INSTALL_DIR/$APP_NAME" /usr/bin/$EXEC_NAME || \
sudo ln -sf "$INSTALL_DIR/$EXEC_NAME" /usr/bin/$EXEC_NAME

ICON_PATH=$(find "$INSTALL_DIR" -type f -name "*.png" | head -1)

echo ">>> Creating desktop entry at $DESKTOP_FILE..."
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=$APP_NAME Application
Exec=$EXEC_NAME
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Utility;Application;
EOL

echo ">>> Updating desktop database..."
update-desktop-database "$(dirname "$DESKTOP_FILE")" || true

echo ">>> $APP_NAME installed successfully! You can run it with: $EXEC_NAME"
