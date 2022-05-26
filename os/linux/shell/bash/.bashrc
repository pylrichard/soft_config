. ~/.autojump/etc/profile.d/autojump.sh

export JAVA_HOME=/usr/local/java/java
export MYSQL_57_HOME=/usr/local/mysql/5.7
export MONGODB_HOME=/usr/local/mongodb/mongodb
export M2_HOME=/usr/local/maven/maven
export ES_HOME=/usr/local/es/es
export KIBANA_HOME=/usr/local/kibana/kibana
export GRADLE_HOME=/usr/local/gradle/gradle
export NODE_HOME=/usr/local/node/node
export CLASS_PATH=./:$JAVA_HOME/lib
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH=$JAVA_HOME/bin:$MONGODB_HOME/bin:$MYSQL_57_HOME/bin:$M2_HOME/bin:$GRADLE_HOME/bin:$NODE_HOME/bin:$ES_HOME/bin:$KIBANA_HOME/bin:$PATH

alias cls='clear'
alias ll='ls -lsh'
alias l='ls -lash'
alias lr='ls -lashR'
alias du='du -sh'
alias df='df -h'
alias vi='vim'
alias grep="grep --color=auto"
alias psgrep='ps -ef | grep'

PS1="\n\[\033[1;30;50m[\033[0;31;50m\u@\033[0;33;50m\h:\033[0;34;50m$(ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:") \033[1;30;50m\w\033[1;30;50m]\033[1;30;50m \]\n"
