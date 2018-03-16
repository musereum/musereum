# MAKEFLAGS += --silent
UI:=
UI_PROTECT:=1
UI_HOSTS:=all
UI_BIND:=0.0.0.0
WS:=
WS_HOSTS:=all
WS_BIND:=0.0.0.0
RPC:=
RPC_APIS:=all
RPC_HOSTS:=all
RPC_BIND:=0.0.0.0
SIGNER:=
BOOTNODE:=
ROOTPATH:=/root
DATAPATH=$(ROOTPATH)/data
KEYSPATH=$(ROOTPATH)/keys
CHAINSPECS=$(ROOTPATH)/genesis.json
PASSWORDSPATH=$(ROOTPATH)/passwords.txt

NODE:=0
NODEPORT:=$(shell expr 30000 + $(NODE))
RPCPORT:=$(shell expr 8545 + $(NODE))
WSPORT:=$(shell expr 9545 + $(NODE))
UIPORT:=$(shell expr 8180 + $(NODE))

NODENAME:=testnet-$(NODE)
LOG_FILE:=$(shell pwd)/output.txt
LOGGING:=>>$(value LOG_FILE) 2>&1

.PHONY: run node
token:
	docker exec -ti \
		testnet_node_1 \
			/musereum \
				--base-path $(DATAPATH) \
				--keys-path $(KEYSPATH) \
				--chain $(CHAINSPECS) \
					signer new-token
					
server-remove:
	hyper stop $(NODENAME)
	hyper rm $(NODENAME)
	hyper volume rm vol-$(NODENAME)

VOL_PATH:=$(shell pwd)
deploy-volume:
	hyper volume create --name vol-$(NODENAME)
	hyper volume init $(VOL_PATH):vol-$(NODENAME)
	make deploy
deploy:
	hyper run -d \
		--env UI=$(UI) \
		--env UI_PROTECT=$(UI_PROTECT) \
		--env UI_HOSTS=$(UI_HOSTS) \
		--env UI_BIND=$(UI_BIND) \
		--env WS=$(WS) \
		--env WS_HOSTS=$(WS_HOSTS) \
		--env WS_BIND=$(WS_BIND) \
		--env RPC=$(RPC) \
		--env RPC_APIS=$(RPC_APIS) \
		--env RPC_HOSTS=$(RPC_HOSTS) \
		--env RPC_BIND=$(RPC_BIND) \
		--env SIGNER=$(SIGNER) \
		--env BOOTNODE=$(BOOTNODE) \
		--env ROOTPATH=$(ROOTPATH) \
		--env DATAPATH=$(DATAPATH) \
		--env KEYSPATH=$(KEYSPATH) \
		--env CHAINSPECS=$(CHAINSPECS) \
		--env PASSWORDSPATH=$(PASSWORDSPATH) \
		--env NODEPORT=$(NODEPORT) \
		--env RPCPORT=$(RPCPORT) \
		--env WSPORT=$(WSPORT) \
		--env UIPORT=$(UIPORT) \
		-p $(RPCPORT):8545 \
		-p $(NODEPORT):30000 \
		-p $(NODEPORT):30000/udp \
		-p $(WSPORT):9545 \
		-p $(UIPORT):8180 \
		-v vol-$(NODENAME):/root \
		--name $(NODENAME) \
		musereum-node /bin/bash /root/run.sh
_run:
	docker run -d \
		--env UI=$(UI) \
		--env UI_PROTECT=$(UI_PROTECT) \
		--env UI_HOSTS=$(UI_HOSTS) \
		--env UI_BIND=$(UI_BIND) \
		--env WS=$(WS) \
		--env WS_HOSTS=$(WS_HOSTS) \
		--env WS_BIND=$(WS_BIND) \
		--env RPC=$(RPC) \
		--env RPC_APIS=$(RPC_APIS) \
		--env RPC_HOSTS=$(RPC_HOSTS) \
		--env RPC_BIND=$(RPC_BIND) \
		--env SIGNER=$(SIGNER) \
		--env BOOTNODE=$(BOOTNODE) \
		--env ROOTPATH=$(ROOTPATH) \
		--env DATAPATH=$(DATAPATH) \
		--env KEYSPATH=$(KEYSPATH) \
		--env CHAINSPECS=$(CHAINSPECS) \
		--env PASSWORDSPATH=$(PASSWORDSPATH) \
		--env NODEPORT=$(NODEPORT) \
		--env RPCPORT=$(RPCPORT) \
		--env WSPORT=$(WSPORT) \
		--env UIPORT=$(UIPORT) \
		-p $(RPCPORT):8545 \
		-p $(NODEPORT):30000 \
		-p $(NODEPORT):30000/udp \
		-p $(WSPORT):9545 \
		-p $(UIPORT):8180 \
		-v $(shell pwd)/genesis.json:$(CHAINSPECS) \
		-v $(shell pwd)/run.sh:/root/run.sh \
		-v $(shell pwd)/accounts.pwd:$(PASSWORDSPATH) \
		-v $(shell pwd)/output.txt:/root/output.txt \
		-v $(shell pwd)/keys:$(KEYSPATH) \
		--name $(NODENAME) \
		-t musereum/musereum:stable \
			//root/run.sh
logs:
	docker logs -f --tail=50 $(NODENAME) | sed -e 's/^/[$(NODENAME)]: /'
run_compose:
	cross-env \
		UI=$(UI) \
		UI_PROTECT=$(UI_PROTECT) \
		UI_HOSTS=$(UI_HOSTS) \
		UI_BIND=$(UI_BIND) \
		WS=$(WS) \
		WS_HOSTS=$(WS_HOSTS) \
		WS_BIND=$(WS_BIND) \
		RPC=$(RPC) \
		RPC_APIS=$(RPC_APIS) \
		RPC_HOSTS=$(RPC_HOSTS) \
		RPC_BIND=$(RPC_BIND) \
		SIGNER=$(SIGNER) \
		BOOTNODE=$(BOOTNODE) \
		ROOTPATH=$(ROOTPATH) \
		DATAPATH=$(DATAPATH) \
		KEYSPATH=$(KEYSPATH) \
		CHAINSPECS=$(CHAINSPECS) \
		PASSWORDSPATH=$(PASSWORDSPATH) \
		NODEPORT=$(NODEPORT) \
		RPCPORT=$(RPCPORT) \
		WSPORT=$(WSPORT) \
		UIPORT=$(UIPORT) \
			docker-compose up -d

network:
	rm -f $(shell pwd)/output.txt
	touch $(shell pwd)/output.txt
	make stop
	make _run NODE=0 UI=1 RPC=1 WS=1
	make _run NODE=1 SIGNER=0xc17f4f087131a7eb5b0e236a80ad1eda456dfb17 BOOTNODE=enode://b65e83577dcbed1cdc66464f9cbbad9b30363df34c690f0b4ed8b0ee3d83bba44e430822a52c7b4aec72dcdc379e04b845d0091b3cbb23d58148899b1ac2666c@172.17.0.2:30000
	make _run NODE=2 SIGNER=0x7c427013a02f84fc14ede64a2b0c1982d657e6ff BOOTNODE=enode://b65e83577dcbed1cdc66464f9cbbad9b30363df34c690f0b4ed8b0ee3d83bba44e430822a52c7b4aec72dcdc379e04b845d0091b3cbb23d58148899b1ac2666c@172.17.0.2:30000
	make _run NODE=3 SIGNER=0x53fdb3636936f6ea7bd0a7adb603e0504abbc722 BOOTNODE=enode://b65e83577dcbed1cdc66464f9cbbad9b30363df34c690f0b4ed8b0ee3d83bba44e430822a52c7b4aec72dcdc379e04b845d0091b3cbb23d58148899b1ac2666c@172.17.0.2:30000
 
	make logs NODE=0

	echo "DONE"

STOP_NAME:=testnet
stop:
	docker stop $(or $(shell docker ps -q -f name=$(STOP_NAME)), 11111) || true
	docker container prune -f

