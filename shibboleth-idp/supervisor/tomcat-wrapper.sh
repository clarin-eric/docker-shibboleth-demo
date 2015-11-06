#!/bin/bash
# Source: https://confluence.atlassian.com/plugins/viewsource/viewpagesrc.action?pageId=252348917
function shutdown()
{
    date
    echo "Shutting down Tomcat"
    unset CATALINA_PID # Necessary in some cases
    unset LD_LIBRARY_PATH # Necessary in some cases
    unset JAVA_OPTS # Necessary in some cases

    $CATALINA_HOME/bin/catalina.sh stop
}

date
NAME=tomcat8
echo "Starting $NAME"
export CATALINA_PID="/var/run/$NAME.pid"
export CATALINA_HOME=/usr/share/$NAME
export CATALINA_BASE=/var/lib/$NAME
export JAVA_HOME=/usr/
export JAVA_OPTS="-Xmx1024m"

. $CATALINA_HOME/bin/catalina.sh start

# Allow any signal which would kill a process to stop Tomcat
trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP

echo "Waiting for `cat $CATALINA_PID`"
wait `cat $CATALINA_PID`
