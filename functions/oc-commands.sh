#!/bin/bash

function oc_login_aws() {
  oc login https://console.prod.bonniernews.io -u $(whoami) && docker login -u $(oc whoami) -p $(oc whoami -t) registry.trusted.ohoy.io
}

function oc_login_elastx() {
 oc login https://console.elx.bonniernews.io -u $(whoami) && docker login -u $(oc whoami) -p $(oc whoami -t) registry.trusted.elx.ohoy.io
} 	
