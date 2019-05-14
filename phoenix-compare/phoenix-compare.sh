#!/bin/bash
#
#  This script compares the output of the SQL provided and checks if there is a difference
#  Can be used to compare DDL or data. Script only retains the generated temp files if the difference is found.
#  
#  Author:  Vijay Anand Karthikeyan
#

OPTS=`getopt --long dir:,sqlfile:,conn1:,conn2:,help:: -n 'parse-options' -- "$@"`

function log {
    echo "`date '+%Y-%m-%d %H:%M:%S'` ${*}"
}

scriptUsage()
{
  log "INFO ---------------------------------------------------------------------------------------"
  log "INFO Please supply the required parameters for the script."
  log "INFO "
  log "INFO          $(basename -- "$0") --conn1 server1:2181/hbase-secure --conn2 server2:2181/hbase-secure --dir /tmp --sqlfile compare.sql"
  log "INFO "
  log "INFO          Mandatory Parameters:"
  log "INFO                       --conn1    	Zookeeper information for environment 1"
  log "INFO                       --conn2    	Zookeeper information for environment 2"
  log "INFO                       --dir      	Directory to dump the output of the SQL"
  log "INFO                       --sqlfile     File containing all sqls seperated by newline"
  log "INFO "
  log "INFO ---------------------------------------------------------------------------------------"
}

if [ $? != 0 ] ; then log "ERROR Failed parsing options." >&2 ; exit 1 ; fi

while true; do
  case "$1" in
    --conn1 )
            case "$2" in
                *) CONNECTION1=$2 ; shift 2 ;;
            esac ;;
    --conn2 )
            case "$2" in
                *) CONNECTION2=$2 ; shift 2 ;;
            esac ;;
    --dir ) 
            case "$2" in
                *) DIRECTORY=$2 ; shift 2 ;;
            esac ;;
    --sqlfile ) 
            case "$2" in
                *) SQLFILE=$2 ; shift 2 ;;
            esac ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

log "INFO ---------------------------------------------------------------------------------------"
log "INFO Parameters supplied for this run - "
log "INFO     Script name:        	$(basename -- ""$0"")"
log "INFO     Connection 1:         	$CONNECTION1"
log "INFO     Connection 2:       	$CONNECTION2"
log "INFO     SQL File:           	$SQLFILE"
log "INFO     Directory:           	$DIRECTORY"
log "INFO ---------------------------------------------------------------------------------------"


if [ "x" == "x$CONNECTION1" ] || [ "x" == "x$CONNECTION2" ] || [ "x" == "x$DIRECTORY" ] || [ "x" == "x$SQLFILE" ]; then
  scriptUsage
  exit 1
fi

sqlFile=$SQLFILE
dir=$DIRECTORY
env1=`echo $CONNECTION1 | awk -F '[./:]' '{print $1}'`
env2=`echo $CONNECTION2 | awk -F '[./:]' '{print $1}'`
environment=( $env1 $env2 )
counter=0

while read sql; do
        counter=$((counter+1))
        # Filter only supported statements
        isSupported=`echo "$sql" |  sed -n '/SELECT\|select\|!describe\|!primarykeys\|!tables/p'`
        if [ "x" == "x$isSupported" ] ; then
                log "WARN  ${sql} not supported"
                log "INFO  ---------------------------------------------------------------------------------------"
                # Move to the next statement after logging the unsupported command
                continue
        fi
        commandName1=`echo "$sql" | grep -i SELECT | sed -n 's/.* FROM \([^ ]*\).*/\1/pI'`
        commandName2=`echo "$sql" | grep -v -i SELECT | sed 's/^!\(.*\)/\1/' |sed -e 's/[[:space:]]/\-/g'`
        commandName=${commandName1}${commandName2}
        log "INFO  ---------------------------------------------------------------------------------------"
        log "INFO  Line Number:                 $counter"
        #log "INFO  Extracted Command:  $commandName"
        log "INFO  Statement:           $sql"
        for i in {0..1}
        do
                env="${environment[$i]}"
                conn="${connection[$i]}"
                prefix="${dir}/${commandName}-${counter}-${env}"

                rm -f ${prefix}.out ${prefix}.txt
                sqlPrefix="!set showelapsedtime false\n!set force true\n!outputformat csv\n!brief\n!record ${prefix}.out\n"
                runCommand=`echo -e "${sqlPrefix} ${sql}" | phoenix-sqlline ${conn} > /dev/null 2>&1`
                if [ $? -eq 0 ]; then
                        log "INFO  Command on ${env} succeeded"
                else
                        log "ERROR  Command on ${env} failed" >&2
                        #log "ERROR  Command executed - ${runCommand}" >&2
                        rm -f "${prefix}.out"
                        continue
                fi
                sed '1d' "${prefix}.out" > "${prefix}.txt"
                rm -f "${prefix}.out"
        done
        getdiff=`diff "${dir}/$commandName-${counter}-${environment[0]}.txt" "${dir}/$commandName-${counter}-${environment[1]}.txt" > ${dir}/${commandName}-${counter}.diff  2>&1`
        if [ $? -eq 2 ]; then
                log "ERROR  Command to get diff failed" >&2
                continue
        else
                log "INFO  Command to get diff succeeded"
        fi
        if [ -s ${dir}/${commandName}-${counter}.diff ]
        then
                log "INFO  Differences found. Check ${dir}/${commandName}-${counter}.diff"
        else
                log "INFO  No differences found"
                rm -f "${dir}/$commandName-${counter}-${environment[0]}.txt" "${dir}/$commandName-${counter}-${environment[1]}.txt" "${dir}/${commandName}-${counter}.diff"
        fi
        log "INFO  ---------------------------------------------------------------------------------------"
done <$sqlFile
