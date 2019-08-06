#!/bin/bash

###### LATEST #####
function es_content_latest_get_article() {
  curl -X GET "http://latest.elasticsearch-nav-content.service.elastx.consul.dex.nu:9201/content-dmedia/content/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "filter": [
          { "term":  { "objectType": "article" }}
        ]
      }
    }
  }
  '
}

function es_content_latest_get_akademi() {
  curl -X GET "http://latest.elasticsearch-nav-content.service.elastx.consul.dex.nu:9201/content-dmedia/content/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "filter": [
          { "term":  { "objectType": "akademi" }}
        ]
      }
    }
  }
  '
}

function es_content_latest_get_event() {
  curl -X GET "http://latest.elasticsearch-nav-content.service.elastx.consul.dex.nu:9201/content-dmedia/content/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "filter": [
          { "term":  { "objectType": "event" }}
        ]
      }
    }
  }
  '
}

######¤ DEV #####
function es_content_dev_get_listingpage() {
  curl -X GET "http://es-content.dev.bonnier.news:9200/content-dmedia/content/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "filter": [
          { "term":  { "objectType": "article" }}
        ]
      }
    }
  }
  '
}

function es_content_dev_get_article() {
  curl -X GET "http://es-content.dev.bonnier.news:9200/content-dmedia/content/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "filter": [
          { "term":  { "objectType": "article" }}
        ]
      }
    }
  }
  '
}

function es_content_dev_get_akademi() {
  curl -X GET "http://es-content.dev.bonnier.news:9200/content-dmedia/content/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "filter": [
          { "term":  { "objectType": "akademi" }}
        ]
      }
    }
  }
  '
}

function es_content_dev_get_event() {
  curl -X GET "http://es-content.dev.bonnier.news:9200/content-dmedia/content/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "filter": [
          { "term":  { "objectType": "event" }}
        ]
      }
    }
  }
  '
}

function es_content_dev_get_article_filter_on_tags() {
  curl -X GET "http://es-content.dev.bonnier.news:9200/content-dmedia/content/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "filter": [
          { "term":  { "objectType": "article" }},
          { "terms":  { "indexed.tags": ["dmedia.contentful.F7GJslxRM4EaywScUisis"] }}
        ]
      }
    }
  }
  '
}

function es_content_dev_put_testdata() {
  # Akademi
  curl -X PUT "http://es-content.dev.bonnier.news:9200/content-dmedia/content/dmedia.doubledutch.999999999" -H "Content-Type: application/json" --data-binary "@/home/patrik.bergman/dev/bash-utilities/test-data/dmedia.doubledutch.999999999.json"

  # Event
  curl -X PUT "http://es-content.dev.bonnier.news:9200/content-dmedia/content/dmedia.doubledutch.888888888" -H "Content-Type: application/json" --data-binary "@/home/patrik.bergman/dev/bash-utilities/test-data/dmedia.doubledutch.888888888.json"

  # Klara article
  curl -X PUT "http://es-content.dev.bonnier.news:9200/content-dmedia/content/dmedia.klara.34bb0a7d-8c56-44ad-be9a-2963a6e46752" -H "Content-Type: application/json" --data-binary "@/home/patrik.bergman/dev/bash-utilities/test-data/dmedia.klara.34bb0a7d-8c56-44ad-be9a-2963a6e46752.json"
}
