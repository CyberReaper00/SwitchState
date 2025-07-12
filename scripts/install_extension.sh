#!/usr/bin/env bash

# List of extension IDs
EXTENSIONS=(
	"fnpbehpgglbfnpimkachnpnecjncndgm" # chromium web store ocaahdebbfolfmndjeplogmgcagdmblk
	"eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
	"fofhikdigdjbhphnekoglnjkoifoldhj" # fuzzy tab finder
	"aapbdbdomjkkjkaonfhkkikfgjllcleb" # google translate
	"fefodpegbocmidnfphgggnjcicipaibk" # notepad
	"cmgdpmlhgjhoadnonobjeekmfcehffco" # ollama-ui
	"cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
	"nbhcbdghjpllgmfilhnhkllmkecfmpld" # user javascript and css
	"hfjbmagddngcpeloejdejnfgbamkjaeg" # vimium c
)

DOWNLOAD_DIR="${HOME}/Downloads/chromium_extensions"
mkdir -p "$DOWNLOAD_DIR"

echo "Downloading Ungoogled-Chromium extensions to $DOWNLOAD_DIR..."

for EXT_ID in "${EXTENSIONS[@]}"; do
    DOWNLOAD_URL="https://clients2.google.com/service/update2/crx?response=redirect&prodversion=CHROMIUM_VERSION&x=id%3D${EXT_ID}%26installsource%3Dondemand%26uc"
    FILE_NAME="${EXT_ID}.crx"

    echo "Downloading ${EXT_ID}..."
    curl -L "$DOWNLOAD_URL" -o "${DOWNLOAD_DIR}/${FILE_NAME}"

    if [ $? -eq 0 ]; then
        echo "Successfully downloaded ${FILE_NAME}"
    else
        echo "Failed to download ${FILE_NAME}"
    fi
done

echo "Downloads complete. To install, open chrome://extensions in Ungoogled-Chromium, enable Developer Mode, and drag each .crx file from ${DOWNLOAD_DIR} onto the page."
