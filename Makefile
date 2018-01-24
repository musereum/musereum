# MAKEFLAGS += --silent
MUSEREUM_ROOT:=$(shell pwd)
SCRIPTS_ROOT:=$(value MUSEREUM_ROOT)/scripts
EXECUTION_PATH:=$(value MUSEREUM_ROOT)/target/release/musereum
BUILD_TYPE:=--release

NODEPORT:=30000
RPCPORT:=8545
WSPORT:=9545
UIPORT:=8000
CHAIN_SPEC:=$(value MUSEREUM_ROOT)/musereum-testnet-genesis.json

DATA_ROOT:=$(value MUSEREUM_ROOT)/.data
LOGS_ROOT:=$(value DATA_ROOT)/logs
BLOCKCHAIN_ROOT:=$(value DATA_ROOT)/chains
KEYS_DIR:=$(value DATA_ROOT)/keys
PASSWORDS_PATH:=$(value DATA_ROOT)/passwords.txt

NODE:=0
BOOTNODE:=enode://75efb05557e0d048befb9c2f64d67a0c0b1dba75a26e10f34facea88512e7f8b9ff4d147b38355ac54c1feb4dd319f36c313ff52a51aa041c252a876149c8160@192.168.199.101:3000

ETHNET_API:=$(value SCRIPTS_ROOT)/eth-net-intelligence-api
ETHNET_UI:=$(value SCRIPTS_ROOT)/eth-netstats
ETHNET_WS:=ws://localhost:3000
ETHNET_SECRET:=TEST_ETHNET
ETHNET_VERBOSITY:=2

.PHONY: netstats-api netstats-ui node bootnode 

build:
	echo Musereum source folder: $(value MUSEREUM_ROOT)
	cargo build -j $(shell sysctl -n hw.ncpu) $(value BUILD_TYPE) --features final --verbose $(value CARGOFLAGS)

test:
	echo "Tests function not implemented yet..."

node:
	# Calculate node enode port
	$(eval \
		PORT:=$(shell expr $(NODEPORT) + $(NODE)) \
	)
	# Calculate node rpc port
	$(eval \
		RPC:=$(shell expr $(RPCPORT) + $(NODE)) \
	)
	# Calculate node ws port
	$(eval \
		WS:=$(shell expr $(WSPORT) + $(NODE)) \
	)
	# Calculate node ui port
	$(eval \
		UI:=$(shell expr $(UIPORT) + $(NODE)) \
	)

	# Blockchain path
	$(eval \
		DATA:=$(shell echo $(BLOCKCHAIN_ROOT)/node$(NODE)) \
	)

	$(eval \
		LOGS:=$(shell echo $(LOGS_ROOT)/node-$(NODE).txt) \
	)

	# run
	mkdir -p $(DATA_ROOT)
	mkdir -p $(BLOCKCHAIN_ROOT)
	mkdir -p $(LOGS_ROOT)
	touch $(LOGS)
	$(shell $(EXECUTION_PATH) \
		-d $(DATA) \
		--chain $(CHAIN_SPEC) \
		--port $(PORT) \
		--keys-path="$(KEYS_DIR)" \
		$(shell if [ "$(WITH_RPC)" = "true" ]; then \
			echo "--jsonrpc-port $(RPC) --jsonrpc-apis web3,eth,net,personal,parity,parity_set,traces,rpc,parity_accounts" \
		; else echo "--no-jsonrpc"; fi) \
		$(shell if [ "$(WITH_UI)" = "true" ]; then \
			echo --ui-port $(UI) \
		; else echo "--no-ui"; fi) \
		$(shell if [ "$(WITH_WS)" = "true" ]; then \
			echo --ws-port $(WS) \
		; else echo "--no-ws"; fi) \
		$(shell if [ "$(SIGNER)" = "" ]; then echo ""; else \
			echo --engine-signer="$(SIGNER)" --password="$(PASSWORDS_PATH) --force-sealing" \
		; fi) \
		--bootnodes="$(BOOTNODE)" \
		$(ARGS) \
		>& $(LOGS) &)
	echo "node $(NODE) runs"

bootnode: 
	make node NODE=0 WITH_RPC=true WITH_UI=true WITH_WS=true ARGS="--rpccorsdomain http://localhost:4444"

stop:
	kill $(shell ps aux | grep -v grep | grep $(EXECUTION_PATH) | awk '{print $$2}')
	pm2 stop stat-0 stat-1 stat-2 stat-3 stat-4 stat-5 stat-6 stat-7 stat-8 stat-9
	kill $(shell ps aux | grep -v grep | grep $(ETHNET_API) | awk '{print $$2}')

netstats-api:
	echo api
	$(eval \
		LISTEN_PORT:=$(shell expr $(NODEPORT) + $(NODE)) \
	)
	$(eval \
		RPC:=$(shell expr $(RPCPORT) + $(NODE)) \
	)
	$(eval \
		LOGS:=$(shell echo $(LOGS_ROOT)/stat-node-$(NODE).txt) \
	)
	$(shell \
		NODE_ENV=production \
		RPC_HOST=localhost \
		RPC_PORT=$(RPC) \
		INSTANCE_NAME="Node $(NODE)" \
		CONTACT_DETAILS="Local Node $(NODE)" \
		LISTENING_PORT=$(LISTEN_PORT) \
		WS_SERVER=$(ETHNET_WS) \
		WS_SECRET=$(ETHNET_SECRET) \
		VERBOSITY=$(ETHNET_VERBOSITY) \
		$(ETHNET_API)/node_modules/.bin/pm2 -n stat-$(NODE) start $(ETHNET_API)/app.js \
	>& $(LOGS) &)

	sleep 1

netstats-ui:
	echo ui
	$(eval \
		LOGS:=$(shell echo $(LOGS_ROOT)/stat-ui.txt) \
	)
	$(eval export WS_SECRET=$(ETHNET_SECRET))
	npm start --prefix $(ETHNET_UI)


connect:
	$(eval \
		BOOTNODE:="$(shell curl -s --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545 | python -c "import sys, json; print json.load(sys.stdin)['result']")" \
	)

	echo $(BOOTNODE)

	$(eval \
		RPC:=$(shell expr $(RPCPORT) + $(NODE)) \
	)

	curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":[$(BOOTNODE)],"id":0}' -H "Content-Type: application/json" -X POST localhost:$(RPC)

apis:

testnet: #stop
	make bootnode 

	make node NODE=1 SIGNER=0x28968999fda1a0604658de8c4807d658e9bfac72 WITH_RPC=true
	make node NODE=2 SIGNER=0xde617c8dec878ee6d2ac810b0b692b8331b0c337 WITH_RPC=true
	make node NODE=3 SIGNER=0x64369389c7b4bca09a682964fe901ac6fb61a8f4 WITH_RPC=true
	make node NODE=4 SIGNER=0xb4ea9042e257c9d2568d7f4c65d40e6f712e8f51 WITH_RPC=true
	make node NODE=5 SIGNER=0x4a2c501632dcec3f413e6d29594909e821ff68e5 WITH_RPC=true
	make node NODE=6 SIGNER=0x32c4bd446788a02e472c108fc2b6b2ad241db08d WITH_RPC=true
	make node NODE=7 SIGNER=0xd2fb746021df48703ebbda976a377a8f0bc053de WITH_RPC=true
	make node NODE=8 SIGNER=0x27f64d6bcb037fb44c26946a58a469a14f7b3434 WITH_RPC=true
	make node NODE=9 SIGNER=0x2fe4cf7166afde6c30790264cb7694a1ff968c60 WITH_RPC=true

	make netstats-api NODE=0
	make netstats-api NODE=1
	make netstats-api NODE=2
	make netstats-api NODE=3
	make netstats-api NODE=4
	make netstats-api NODE=5
	make netstats-api NODE=6
	make netstats-api NODE=7
	make netstats-api NODE=8
	make netstats-api NODE=9

	echo "wait for boot up"
	sleep 15
	make connect NODE=1
	make connect NODE=2
	make connect NODE=3
	make connect NODE=4
	make connect NODE=5
	make connect NODE=6
	make connect NODE=7
	make connect NODE=8
	make connect NODE=9

restart-net: 
	kill $(shell ps aux | grep -v grep | grep $(ETHNET_API) | awk '{print $$2}')
	kill $(shell lsof -n -i:3000 | grep -v PID | awk '{print $$2}' )
	make netstats-api NODE=0
	make netstats-api NODE=1
	make netstats-api NODE=2
	make netstats-api NODE=3
	make netstats-api NODE=4
	make netstats-api NODE=5
	make netstats-api NODE=6
	make netstats-api NODE=7
	make netstats-api NODE=8
	make netstats-api NODE=9