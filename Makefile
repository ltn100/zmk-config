.PHONY: all
all: left right settings_reset

.PHONY: init
init: .west

.PHONY: left
left: init build/left/zephyr/zmk.uf2

.PHONY: right
right: init build/right/zephyr/zmk.uf2

.PHONY: settings_reset
settings_reset: init build/settings_reset/zephyr/zmk.uf2

NICE_NANO_NAME=NICENANO
NICE_NANO_BLK=$(shell lsblk -lnpb --output NAME,RM,FSTYPE,PARTLABEL,LABEL,UUID,MOUNTPOINT | grep $(NICE_NANO_NAME) | awk '{print $$1}')


.PHONY: info
info:
	echo $(NICE_NANO_BLK)

.west:
	@[ -z "$(VIRTUAL_ENV)" ] \
	&& \
		echo "Not in a virtual environment" && \
		exit 1 \
	|| \
		pip install -r requirements.txt && \
		west init -l config/ && \
		west update && \
	:

build/left/zephyr/zmk.uf2: FORCE
	west build -s zmk/app/ -p \
		-d build/left \
		-b nice_nano_v2 \
		-S studio-rpc-usb-uart \
		-- \
			-DSHIELD=lily58_left \
			-DZMK_CONFIG="$(shell pwd)/config" \
	;

build/right/zephyr/zmk.uf2: FORCE
	west build -s zmk/app/ -p \
		-d build/right \
		-b nice_nano_v2 \
		-S studio-rpc-usb-uart \
		-- \
			-DSHIELD=lily58_right \
			-DZMK_CONFIG="$(shell pwd)/config" \
	;

build/settings_reset/zephyr/zmk.uf2:
	west build -s zmk/app/ -p \
		-d build/settings_reset \
		-b nice_nano_v2 \
		-- \
			-DSHIELD=settings_reset \
	;

.PHONY: copy_left
copy_left:
	cp build/left/zephyr/zmk.uf2 \
	$(shell \
		udisksctl mount -b $(NICE_NANO_BLK) 1>/dev/null 2>&1; \
		sleep 1; \
		udisksctl info -b $(NICE_NANO_BLK) | grep MountPoints | awk '{print $$2}' \
	)

.PHONY: copy_right
copy_right:
	cp build/right/zephyr/zmk.uf2 \
	$(shell \
		udisksctl mount -b $(NICE_NANO_BLK) 1>/dev/null 2>&1; \
		sleep 1; \
		udisksctl info -b $(NICE_NANO_BLK) | grep MountPoints | awk '{print $$2}' \
	)
	

# -- Dongle targets
.PHONY: dongle
dongle: dongle_central dongle_left dongle_right settings_reset

.PHONY: dongle_central
dongle_central: init build/dongle_central/zephyr/zmk.uf2

.PHONY: dongle_left
dongle_left: init build/dongle_left/zephyr/zmk.uf2

.PHONY: dongle_right
dongle_right: init build/dongle_right/zephyr/zmk.uf2

.PHONY: copy_dongle_central
copy_dongle_central:
	cp build/dongle_central/zephyr/zmk.uf2 \
	$(shell \
		udisksctl mount -b $(NICE_NANO_BLK) 1>/dev/null 2>&1; \
		sleep 1; \
		udisksctl info -b $(NICE_NANO_BLK) | grep MountPoints | awk '{print $$2}' \
	)

.PHONY: copy_dongle_left
copy_dongle_left:
	cp build/dongle_left/zephyr/zmk.uf2 \
	$(shell \
		udisksctl mount -b $(NICE_NANO_BLK) 1>/dev/null 2>&1; \
		sleep 1; \
		udisksctl info -b $(NICE_NANO_BLK) | grep MountPoints | awk '{print $$2}' \
	)

.PHONY: copy_dongle_right
copy_dongle_right:
	cp build/dongle_right/zephyr/zmk.uf2 \
	$(shell \
		udisksctl mount -b $(NICE_NANO_BLK) 1>/dev/null 2>&1; \
		sleep 1; \
		udisksctl info -b $(NICE_NANO_BLK) | grep MountPoints | awk '{print $$2}' \
	)

build/dongle_central/zephyr/zmk.uf2: FORCE
	west build -s zmk/app/ -p \
		-d build/dongle_central \
		-b nice_nano_v2 \
		-S studio-rpc-usb-uart \
		-- \
			-DSHIELD=lily58_dongle \
			-DZMK_CONFIG="$(shell pwd)/config" \
			-DCONFIG_ZMK_DISPLAY=n \
	;
build/dongle_left/zephyr/zmk.uf2: FORCE
	west build -s zmk/app/ -p \
		-d build/dongle_left \
		-b nice_nano_v2 \
		-S studio-rpc-usb-uart \
		-- \
			-DSHIELD=lily58_left \
			-DZMK_CONFIG="$(shell pwd)/config" \
			-DCONFIG_ZMK_SPLIT_ROLE_CENTRAL=n \
	;

build/dongle_right/zephyr/zmk.uf2: FORCE
	west build -s zmk/app/ -p \
		-d build/dongle_right \
		-b nice_nano_v2 \
		-S studio-rpc-usb-uart \
		-- \
			-DSHIELD=lily58_right \
			-DZMK_CONFIG="$(shell pwd)/config" \
			-DCONFIG_ZMK_SPLIT_ROLE_CENTRAL=n \
	;

FORCE: ;