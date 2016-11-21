#!/bin/bash - 

list_java_pids() {
    ps aux | grep jav[a] | awk '{print $1}'
}    

kill_java_processes() {
    ps aux | grep jav[a] | awk '{print $2}' | xargs kill
}    

