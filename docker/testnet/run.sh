#!/bin/bash
# colors
# Reset
C_Off='\e[0m'       # Text Reset

# Regular Colors
C_Black='\e[0;30m'        # Black
C_Red='\e[0;31m'          # Red
C_Green='\e[0;32m'        # Green
C_Yellow='\e[0;33m'       # Yellow
C_Blue='\e[0;34m'         # Blue
C_Purple='\e[0;35m'       # Purple
C_Cyan='\e[0;36m'         # Cyan
C_White='\e[0;37m'        # White

# Bold
C_B_Black='\033[1;30m'       # Black
C_B_Red='\033[1;31m'         # Red
C_B_Green='\033[1;32m'       # Green
C_B_Yellow='\033[1;33m'      # Yellow
C_B_Blue='\033[1;34m'        # Blue
C_B_Purple='\033[1;35m'      # Purple
C_B_Cyan='\033[1;36m'        # Cyan
C_B_White='\033[1;37m'       # White

# Underline
C_UBlack='\033[4;30m'       # Black
C_URed='\033[4;31m'         # Red
C_UGreen='\033[4;32m'       # Green
C_UYellow='\033[4;33m'      # Yellow
C_UBlue='\033[4;34m'        # Blue
C_UPurple='\033[4;35m'      # Purple
C_UCyan='\033[4;36m'        # Cyan
C_UWhite='\033[4;37m'       # White

# Background
C_BG_Black='\033[40m'       # Black
C_BG_Red='\033[41m'         # Red
C_BG_Green='\033[42m'       # Green
C_BG_Yellow='\033[43m'      # Yellow
C_BG_Blue='\033[44m'        # Blue
C_BG_Purple='\033[45m'      # Purple
C_BG_Cyan='\033[46m'        # Cyan
C_BG_White='\033[47m'       # White

# High Intensity
C_I_Black='\033[0;90m'       # Black
C_I_Red='\033[0;91m'         # Red
C_I_Green='\033[0;92m'       # Green
C_I_Yellow='\033[0;93m'      # Yellow
C_I_Blue='\033[0;94m'        # Blue
C_I_Purple='\033[0;95m'      # Purple
C_I_Cyan='\033[0;96m'        # Cyan
C_I_White='\033[0;97m'       # White

# Bold High Intensity
C_BI_Black='\033[1;90m'      # Black
C_BI_Red='\033[1;91m'        # Red
C_BI_Green='\033[1;92m'      # Green
C_BI_Yellow='\033[1;93m'     # Yellow
C_BI_Blue='\033[1;94m'       # Blue
C_BI_Purple='\033[1;95m'     # Purple
C_BI_Cyan='\033[1;96m'       # Cyan
C_BI_White='\033[1;97m'      # White

# High Intensity backgrounds
C_BGI_Black='\033[0;100m'   # Black
C_BGI_Red='\033[0;101m'     # Red
C_BGI_Green='\033[0;102m'   # Green
C_BGI_Yellow='\033[0;103m'  # Yellow
C_BGI_Blue='\033[0;104m'    # Blue
C_BGI_Purple='\033[0;105m'  # Purple
C_BGI_Cyan='\033[0;106m'    # Cyan
C_BGI_White='\033[0;107m'   # White


echo -e "${C_BGI_Green}                                            ${C_Off}"
echo -e "${C_BGI_Green}    _______        _              _         ${C_Off}"
echo -e "${C_BGI_Green}   |__   __|      | |            | |        ${C_Off}"
echo -e "${C_BGI_Green}      | | ___  ___| |_ _ __   ___| |_       ${C_Off}"
echo -e "${C_BGI_Green}      | |/ _ \/ __| __| '_ \ / _ \ __|      ${C_Off}"
echo -e "${C_BGI_Green}      | |  __/\__ \ |_| | | |  __/ |_       ${C_Off}"
echo -e "${C_BGI_Green}      |_|\___||___/\__|_| |_|\___|\__|      ${C_Off}"
echo -e "${C_BGI_Green}                                            ${C_Off}"

header_print () {
  echo -e "\n\n${C_B_Green}$1${C_Off}:"
}
feature_status () {
  local LABEL=$1
  local STATUS=$2
  if [ -n "$STATUS" ]
  then
    echo -e "\
${C_B_Yellow}${LABEL}${C_Off}  -  \
${C_Green}Enable${C_Off}"
  else
    echo -e "\
${C_B_Yellow}${LABEL}${C_Off}  -  \
${C_Red}Disable${C_Off}"
  fi
}

value_print () {
  local LABEL=$1
  local VALUE=$2
  echo -e "\
${C_B_Yellow}${LABEL}${C_Off}  -  \
${C_Green}${VALUE}${C_Off}"
}

function join_by () { 
  local IFS="$1"; shift; echo "$*"; 
}

header_print   "Features"
feature_status "UI          " $UI
feature_status "WebSokets   " $WS
feature_status "Web3        " $RPC
feature_status "Signer      " $SIGNER
feature_status "Bootnode    " $BOOTNODE

header_print   "Paths"
value_print    "Root path   " $ROOTPATH
value_print    "Data path   " $DATAPATH
value_print    "Keys path   " $KEYSPATH
value_print    "Specs       " $CHAINSPECS
value_print    "Passwords   " $PASSWORDSPATH

header_print   "Ports"
value_print    "Node port   " $NODEPORT
value_print    "RPC port    " $RPCPORT
value_print    "WS port     " $WSPORT
value_print    "UI port     " $UIPORT

check_api () {
  if [ -z "$$1"]
  then
    PRC_APIS+=("$1")
  fi
}


ARGS+=" --base-path ${DATAPATH}"
ARGS+=" --keys-path ${KEYSPATH}"
ARGS+=" --chain ${CHAINSPECS}"
ARGS+=" --port 30000"
if [ -z $RPC ]
then 
  ARGS+=" --no-jsonrpc"
else
  ARGS+=" --jsonrpc-apis ${RPC_APIS}"
  ARGS+=" --jsonrpc-hosts ${RPC_HOSTS}"
  ARGS+=" --jsonrpc-interface ${RPC_BIND}"
  ARGS+=" --jsonrpc-cors ${RPC_HOSTS}"
fi

if [ -z "$UI" ]
then
  ARGS+=" --no-ui"
else
  ARGS+=" --ui-hosts ${UI_HOSTS}"
  ARGS+=" --ui-interface ${UI_BIND}"
  if [ -z "$UI_PROTECT" ]
  then
    ARGS+=" --ui-no-validation"
  fi
fi

if [ -z "$WS" ]
then 
  ARGS+=" --no-ws"
else
  ARGS+=" --ws-port 9545"
fi

if [ -n "$SIGNER" ]
then
  ARGS+=" --engine-signer=$SIGNER --password=/root/passwords.txt --force-sealing"
fi

if [ -n "$BOOTNODE" ]
then
  ARGS+=" --bootnodes=$BOOTNODE"
fi

ARGS+=" --unsafe-expose"

echo "/musereum $ARGS -account_bloom,basicauthority,chain,client,dapps,discovery,diskmap,enact,engine,estimate_gas,ethash,executive,ext,external_tx,externalities,fatdb,fetch,hypervisor,ipc,jdb,journaldb,les,les_provider,local_store,migration,miner,mode,network,on_demand,own_tx,perf,poa,rcdb,shutdown,signer,snapshot,snapshot_io,snapshot_watcher,spec,state,stats,stratum,sync,trie,txqueue,updater=trace"
echo "passowrdS:"
cat /root/passwords.txt
echo ""
/musereum $ARGS &
tail -f /root/output.txt