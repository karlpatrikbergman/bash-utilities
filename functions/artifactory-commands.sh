#!/bin/bash - 

list_xtm_container_versions() {
    curl -X GET "http://se-artif-prd.infinera.com:8081/artifactory/api/docker/docker-local2/v2/tm3k/trunk-hostenv/tags/list" -H "X-JFrog-Art-Api:AKCp2WXqy3gY16wSNimUHMwV5hEqFJz6EiZXd92M6Pr54ZNhugDniiJiZhxpgBcR9nftPrLco"
}    


list_docker_repositories() {
    curl -X GET "http://se-artif-prd.infinera.com:8081/artifactory/api/docker/docker-local2/v2/_catalog" -H "X-JFrog-Art-Api:AKCp2WXqy3gY16wSNimUHMwV5hEqFJz6EiZXd92M6Pr54ZNhugDniiJiZhxpgBcR9nftPrLco"
}
