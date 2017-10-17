#!/bin/bash - 

java_list_pids() {
    ps aux | grep jav[a] | awk '{print $1}'
}    

java_kill_processes() {
    ps aux | grep jav[a] | awk '{print $2}' | xargs kill
}    

