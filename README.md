https://zmk.dev/docs/development/local-toolchain/setup/native

```shell
git clone https://github.com/zmkfirmware/zmk.git
git clone https://github.com/ltn100/zmk-config.git
cd zmk
python -m venv .venv
source .venv/bin/activate
pip install -r ../zmk-config/requirements.txt
west init -l app/
west update
```


## Building

```shell
west build -s ./app/ -p -d build/left -b nice_nano_v2 -S studio-rpc-usb-uart -- -DSHIELD=lily58_left -DZMK_CONFIG="$(pwd)/../zmk-config/config"
west build -s ./app/ -p -d build/right -b nice_nano_v2 -S studio-rpc-usb-uart -- -DSHIELD=lily58_right -DZMK_CONFIG="$(pwd)/../zmk-config/config"
```