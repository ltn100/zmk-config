# zmk-config for Lily58

## Building for a split keyboard (2 microcontrollers)

Ensure local toolchain dependencies are installed:
https://zmk.dev/docs/development/local-toolchain/setup/native

Create a python virtual environment:
```shell
git clone https://github.com/ltn100/zmk-config.git
cd zmk-config
python -m venv .venv
source .venv/bin/activate
```

Run the make `all` target:
```shell
make
```

Put the microcontroler in bootloader mode and then copy the relevant firmwares:
```shell
make copy_left
make copy_right
```

## Building for a dongle keyboard (3 microcontrollers)

```shell
make dongle
```

Put the microcontroler in bootloader mode and then copy the relevant firmwares:
```shell
make copy_dongle_central
make copy_dongle_left
make copy_dongle_right
```
