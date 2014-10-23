#!/usr/bin/env bash

# This file contains environment variables required to run Tachyon. Copy it as tachyon-env.sh and
# edit that to configure Tachyon for your site. At a minimum,
# the following variables should be set:
#
# - JAVA_HOME, to point to your JAVA installation
# - TACHYON_MASTER_ADDRESS, to bind the master to a different IP address or hostname
# - TACHYON_UNDERFS_ADDRESS, to set the under filesystem address.
# - TACHYON_WORKER_MEMORY_SIZE, to set how much memory to use (e.g. 1000mb, 2gb) per worker
# - TACHYON_RAM_FOLDER, to set where worker stores in memory data
# - TACHYON_UNDERFS_HDFS_IMPL, to set which HDFS implementation to use (e.g. com.mapr.fs.MapRFileSystem,
#   org.apache.hadoop.hdfs.DistributedFileSystem)

# The following gives an example:

source ~/ec2-variables.sh
if [[ `uname -a` == Darwin* ]]; then
  # Assuming Mac OS X
  export JAVA_HOME=${JAVA_HOME:-$(/usr/libexec/java_home)}
  export TACHYON_RAM_FOLDER=/Volumes/ramdisk
  export TACHYON_JAVA_OPTS="-Djava.security.krb5.realm= -Djava.security.krb5.kdc="
else
  # Assuming Linux
  if [ -z "$JAVA_HOME" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
  fi
  export TACHYON_RAM_FOLDER=/mnt/ramdisk
fi

export JAVA="$JAVA_HOME/bin/java"
export TACHYON_MASTER_ADDRESS=$VELOX_TACHYON_MASTER
# export TACHYON_MASTER_ADDRESS=localhost
export TACHYON_UNDERFS_ADDRESS=/mnt/tachyon1/tachyon-files
#export TACHYON_UNDERFS_ADDRESS=hdfs://localhost:9000
export TACHYON_WORKER_MEMORY_SIZE=$VELOX_TACHYON_MEM
export TACHYON_UNDERFS_HDFS_IMPL=org.apache.hadoop.hdfs.DistributedFileSystem

CONF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export TACHYON_JAVA_OPTS+="
  -Dlog4j.configuration=file:$CONF_DIR/log4j.properties
  -Dtachyon.debug=false
  -Dtachyon.underfs.address=$TACHYON_UNDERFS_ADDRESS
  -Dtachyon.underfs.hdfs.impl=$TACHYON_UNDERFS_HDFS_IMPL
  -Dtachyon.data.folder=$TACHYON_UNDERFS_ADDRESS/tachyon/data
  -Dtachyon.workers.folder=$TACHYON_UNDERFS_ADDRESS/tachyon/workers
  -Dtachyon.worker.memory.size=$TACHYON_WORKER_MEMORY_SIZE
  -Dtachyon.worker.data.folder=$TACHYON_RAM_FOLDER/tachyonworker/
  -Dtachyon.master.worker.timeout.ms=60000
  -Dtachyon.master.hostname=$TACHYON_MASTER_ADDRESS
  -Dtachyon.master.journal.folder=$TACHYON_UNDERFS_ADDRESS/tachyon/journal/
  -Dorg.apache.jasper.compiler.disablejsr199=true
  -Djava.net.preferIPv4Stack=true
"

# Master specific parameters. Default to TACHYON_JAVA_OPTS.
export TACHYON_MASTER_JAVA_OPTS="$TACHYON_JAVA_OPTS"

# Worker specific parameters that will be shared to all workers. Default to TACHYON_JAVA_OPTS.
export TACHYON_WORKER_JAVA_OPTS="$TACHYON_JAVA_OPTS"
