#!/usr/bin/env bash

#set -u
#set -x

script_name=`basename "$0"`

declare -r DEV="http://es-content.dev.bonnier.news:9200"
declare -r LATEST="http://latest.elasticsearch-nav-content.service.elastx.consul.dex.nu:9201"

########################################################################################################################

function get_raw_source_content_obj() {
  if [[ "$#" -ne 2 ]]; then
    echo "Usage: ${FUNCNAME[0]} <environment> <raw-id>"
    echo "Creates a file named <raw-id>.json in current directory"
  fi
  echo ${1} ${2}
  curl ${1}/flow-raw/raw/${2} | jq '._source.contentObject'  > ${2}.json
  #| jq '._source.contentObject' > ${1}.json
}

function get_raw_source_content_obj_dev() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: ${FUNCNAME[0]} <raw-id>\n"
    echo "Creates a file named <raw-id>.json in current directory"
  fi
  echo ${DEV} ${1}
  get_raw_source_content_obj ${DEV} ${1}
  #curl http://latest.elasticsearch-nav-content.service.elastx.consul.dex.nu:9201/flow-raw/raw/${1} | jq '._source.contentObject' > ${1}.json
}

function get_raw_source_content_obj_latest() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: ${FUNCNAME[0]} <raw-id>\n"
    echo "Creates a file named <raw-id>.json in current directory"
  fi
  echo ${LATEST} ${1}
  get_raw_source_content_obj ${LATEST} ${1}
  #curl http://latest.elasticsearch-nav-content.service.elastx.consul.dex.nu:9201/flow-raw/raw/${1} | jq '._source.contentObject' > ${1}.json
}

########################################################################################################################

function get_content_source() {
  if [[ "$#" -ne 2 ]]; then
    echo "Usage: ${FUNCNAME[0]} <environment> <content-id>"
    echo "Creates a file named <content-id>.json in current directory"
  fi
  curl ${1}/content-dmedia/content/${2} | jq '._source' > ${2}.json
}

function get_content_source_dev() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: ${FUNCNAME[0]} <content-id>"
    echo "Creates a file named <content-id>.json in current directory"
  fi
  get_content_source ${DEV} ${1}
}

function get_content_source_latest() {
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: ${FUNCNAME[0]} <content-id>"
    echo "Creates a file named <content-id>.json in current directory"
  fi
  get_content_source ${LATEST} ${1}
}

########################################################################################################################

#function get_content_source_document_latest() {
#  if [[ "$#" -ne 1 ]]; then
#        echo "Usage: ${FUNCNAME[0]} <content-id>\n"
#        echo "Creates a file named <content-id>.json in current directory"
#  fi
#  raw_id=${1}
#  curl http://latest.elasticsearch-nav-content.service.elastx.consul.dex.nu:9201/content-dmedia/content/${1} | jq '._source.document' > ${1}.json
#}
