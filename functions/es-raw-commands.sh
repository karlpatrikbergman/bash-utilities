#!/bin/bash

###### LATEST #####
function es_raw_latest_get_articles() {
  curl -X GET "http://latest.elasticsearch-nav-content.service.elastx.consul.dex.nu:9201/flow-raw/raw/_search" -H 'Content-Type: application/json' -d'
  {
    "from" : 0, "size" : 10,
    "query": {
      "bool": {
        "filter": [
          { "term":  { "_meta._objectType": "article" }},
          { "term":  { "_meta._sourceSystem": "masterly-dmedia" }}
        ]
      }
    }
  }
  '
}

######¤ DEV #####

function es_raw_dev_put_testdata() {
  # Klara articleTypes
  curl -X PUT "http://es-content.dev.bonnier.news:9200/flow-raw/raw/klara-dmedia.772ea133-738f-480c-95c9-11c64329fc3e" -H "Content-Type: application/json" --data-binary "@/home/patrik.bergman/dev/bash-utilities/test-data/klara-dmedia.772ea133-738f-480c-95c9-11c64329fc3e.json"
  curl -X PUT "http://es-content.dev.bonnier.news:9200/flow-raw/raw/klara-dmedia.0f9ad4e2-d129-4438-8488-e134994b2d4f" -H "Content-Type: application/json" --data-binary "@/home/patrik.bergman/dev/bash-utilities/test-data/klara-dmedia.0f9ad4e2-d129-4438-8488-e134994b2d4f.json"
}
