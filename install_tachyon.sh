#!/usr/bin/env sh

mvn package -DskipTests
mvn install:install-file -Dfile=core/target/tachyon-0.6.0-SNAPSHOT-jar-with-dependencies.jar -DgroupId=org.tachyonproject -DartifactId=tachyon-parent -Dversion=0.6.0-SNAPSHOT -Dpackaging=jar
