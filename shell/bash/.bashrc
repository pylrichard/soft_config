. ~/.autojump/etc/profile.d/autojump.sh

export JAVA_HOME=/usr/java
export JRE_HOME=$JAVA_HOME/jre
export HADOOP_HOME=/usr/local/hadoop/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
export SCALA_HOME=/usr/local/scala/scala
export SPARK_HOME=/usr/local/spark/spark
export MYSQL_57_HOME=/usr/local/mysql/mysql_57
export MYSQL_56_HOME=/usr/local/mysql/mysql_56
export MONGODB_HOME=/usr/local/mongodb/mongodb
export HIVE_HOME=/usr/local/hive/hive
export M2_HOME=/usr/local/maven/maven
export ES_HOME=/usr/local/elasticsearch/elasticsearch
export KIBANA_HOME=/usr/local/kibana/kibana
export GRADLE_HOME=/usr/local/gradle/gradle
export NODE_HOME=/usr/local/node/node
export ZOOKEEPER_HOME=/usr/local/zookeeper/zookeeper
export CLASS_PATH=./:$JAVA_HOME/lib:$JRE_HOME/lib:$HIVE_HOME/lib
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH=$JAVA_HOME/bin:$MONGODB_HOME/bin:$MYSQL_57_HOME/bin:$MYSQL_56_HOME/bin:$M2_HOME/bin:$GRADLE_HOME/bin:$NODE_HOME/bin:$SPARK_HOME/sbin:$SCALA_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin:$ZOOKEEPER_HOME/bin:$ES_HOME/bin:$KIBANA_HOME/bin:$PATH

alias cls='clear'
alias ll='ls -lsh'
alias l='ls -lash'
alias lr='ls -lashR'
alias du='du -sh'
alias df='df -h'
alias vi='vim'
alias grep="grep --color=auto"

PS1="\n\[\033[1;30;50m[\033[0;31;50m\u@\033[0;33;50m\h:\033[0;34;50m$(ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:") \033[1;30;50m\w\033[1;30;50m]\033[1;30;50m \]\n"
