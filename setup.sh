#!/bin/bash

home_dir=/home/pylrichard
workspace_dir=$home_dir/Workspace
config_dir=$workspace_dir/soft_config
ide_dir=/usr/local/ide
src_dir=$home_dir/soft
idea_dir=$workspace_dir/idea_project
pycharm_dir=$workspace_dir/pycharm_project

soft_list="tree sysstat iotop ntp"
download_tool=wget
#并行下载参数，注意空格
#aria2c --help | grep " -x"
#aria2c --help | grep " -j"
#建立软链接
#sudo ln -s /usr/bin/aria2c /usr/bin/aria2
#download_tool=aria2

function is_centos {
    if test -L /etc/redhat-release
    then
        return 0
    else
        return 1
    fi
}

function is_ubuntu {
    if test -f /etc/lsb-release
    then
        return 0
    else
        return 1
    fi
}

if is_centos
then
    pkg_dir=$home_dir/soft
fi

if is_ubuntu
then
    pkg_dir=/mnt/hgfs/soft
fi

function create_dir {
    if is_ubuntu
    then
        if [ ! -d $idea_dir ]
        then
            mkdir -p $idea_dir
        fi

        if [ ! -d $pycharm_dir ]
        then
            mkdir -p $pycharm_dir
        fi
    fi

    if [ ! -d $src_dir ]
    then
        mkdir $src_dir
    fi
}

function rm_src_dir {
    rm -rf $src_dir
}

function configure_user {
    echo -e "set root passwd\n"
    sudo passwd root

    echo -e "\nset pylrichard passwd\n"
    sudo passwd pylrichard
}

function setup_zsh {
    echo -e "\nsetup zsh\n"

    cd $pkg_dir
    tar jxf zsh-5.4.2.tar.bz2 -C $src_dir
    cd $src_dir/zsh-5.4.2
    #生成configure
    ./Util/preconfig
    sleep 1
    ./configure
    make -j 4
    sudo make install.bin
    sudo make install.modules
    sudo make install.fns

    configure_zsh
}

function configure_zsh {
    echo -e "\nconfigure zsh\n"

    sudo chmod 666 /etc/shells
    sudo echo /bin/zsh >> /etc/shells
    sudo ln -s /usr/local/bin/zsh /bin/zsh
    #报错chsh: PAM: Authentication failure
    #注释/etc/pam.d/chsh中的auth required pam_shells.so
    #或者修改/etc/passwd中行末尾的登录shell
    #chsh -s /bin/zsh

    setup_oh_my_zsh
}

function setup_oh_my_zsh {
    echo -e "\nsetup oh my zsh\n"

    sh -c "$($download_tool https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    cd $config_dir
    cp ./shell/zsh/blinks.zsh-theme $home_dir/.oh-my-zsh/themes/
}

function setup_vim_runtime {
    echo -e "\nsetup vim runtime\n"

    #git clone https://github.com/amix/vimrc.git $home_dir/.vim_runtime
    cd $pkg_dir
    tar jxf vim_runtime.tar.bz2 -C ~
    sh $home_dir/.vim_runtime/install_awesome_vimrc.sh
    #cp ./vim/vimrcs/basic.vim $home_dir/.vim_runtime/vimrcs/
    sudo cp -ra $home_dir/.vim_runtime /root
    sudo chown -R root:root /root/.vim_runtime
    cd $config_dir
}

function setup_git_recall {
    echo -e "\nsetup git recall\n"

    git clone https://github.com/Fakerr/git-recall.git $src_dir/git-recall
    cd $src_dir/git-recall
    sudo make install
    cd $config_dir
}

function setup_autojump {
    echo -e "\nsetup autojump\n"

    #git clone https://github.com/wting/autojump.git $src_dir/autojump
    #cd $src_dir/autojump
    cd $pkg_dir
    tar jxf autojump.tar.bz2 -C $src_dir
    cd $src_dir/autojump
    ./install.py
    sudo ln -s ~/.autojump/bin/autojump /usr/local/bin/autojump
    sudo cp -ra ~/.autojump /root
    sudo chown -R root:root /root/.autojump
    cd $config_dir
}

function setup_java {
    echo -e "\nsetup java\n"

    sudo mkdir /usr/local/jdk
    sudo tar jxf $pkg_dir/jdk_1.8.0.121.tar.bz2 -C /usr/local/jdk
    sudo ln -s /usr/local/jdk/jdk_1.8.0.121 /usr/java
    sudo rm -rf /usr/bin/java
    sudo ln -s /usr/java/bin/java /usr/bin/java
}

function setup_python {
    echo -e "\nsetup python\n"

    #$download_tool https://bootstrap.pypa.io/get-pip.py -P $src_dir
    #sudo python $src_dir/get-pip.py
    sudo python $pkg_dir/get-pip.py
    cd $config_dir
    cp -ra pip/.pip ~

    #手工安装mysql_python
    #在setup_posix.py内设置
    #mysql_config.path=mysql安装路径/bin/mysql_config
    #安装ipdb和psutil需要先通过apt安装python2.7-dev
    #python2.7只能使用ipython 5.x版本，新版本只支持python3
    #jedi需要查资料如何使用
    pkgs=("psutil" "glances" "httpie" "mycli" "ipdb")
    for pkg in ${pkgs[@]}
    do
        #-e支持\n换行符
        echo -e "\ninstall $pkg...\n"
        sudo pip install $pkg
    done
}

function setup_ide {
    echo -e "\nsetup ide\n"

    #解压配置文件
    tar jxvf $pkg_dir/ide/idea_settings.tar.bz2 -C $home_dir
    tar jxvf $pkg_dir/ide/pycharm_settings.tar.bz2 -C $home_dir
    #解压安装包
    sudo mkdir -p $ide_dir
    sudo tar jxvf $pkg_dir/ide/idea.tar.bz2 -C $ide_dir
    sudo tar jxvf $pkg_dir/ide/pycharm.tar.bz2 -C $ide_dir
    cd $config_dir
    #添加图标到桌面
    cp ./ide/*.desktop ~/Desktop
}

function setup_db {
    echo -e "\nsetup db\n"

    if [ ! -d $workspace_dir/db_study ]
    then
        git clone https://github.com/pylrichard/db_study.git $workspace_dir/db_study
    fi

    cd $workspace_dir/db_study/mysql/script
    #切换到root，-s执行1个shell脚本
    #-c执行1条命令
    su root -s /bin/bash ./5.7_install.sh /mnt/hgfs/soft/mysql/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz single 1
    sudo systemctl start mysql.server.service
}

function setup_bd {
    echo -e "\nsetup bd\n"

    if [ ! -d $idea_dir/big_data_study ]
    then
        git clone https://github.com/pylrichard/big_data_study.git $idea_dir/big_data_study
    fi

    cd $idea_dir/big_data_study
}

function checkout_git_repo {
    echo -e "\ncheckout git repo\n"

    git clone https://github.com/pylrichard/java_study.git $idea_dir/java_study
    git clone https://github.com/pylrichard/python_study.git $pycharm_dir/python_study
    git clone https://github.com/pylrichard/linux_study.git $workspace_dir/linux_study
}

function cp_git_config {
    echo -e "\ncp git config\n"

    cd $config_dir
    cp ./git/.gitconfig $home_dir
    sudo cp ./git/.gitconfig /root
}

function cp_shell_config {
    echo -e "\ncp shell config\n"

    cd $config_dir
    cp ./shell/bash/.bash* ./shell/bash/.inputrc ~
    sudo cp ./shell/bash/.bash* ./shell/bash/.inputrc /root

    cp ./shell/zsh/.zshrc ~
}

function cp_mvn_config {
    if test -d $home_dir/.m2
    then
        cd $config_dir
        cp ./maven/settings.xml $home_dir/.m2
    fi
}

function setup_soft {
    if is_ubuntu
    then
        setup_zsh
    fi
    cp_shell_config
    cp_git_config
    setup_vim_runtime
    setup_autojump
    setup_java
}

function setup_ubuntu {
    configure_user
    create_dir
    
    #sudo cp ./apt/sources.list /etc/apt
    #sudo apt-get update
    sudo apt-get -y install $soft_list autoconf ncurses-dev tmux tcl libmysqlclient-dev python2.7-dev
    
    setup_soft
    setup_git_recall
    setup_ide
    setup_python
    setup_db
    
    sudo apt-get clean
}

function setup_centos {
    create_dir
    
    $download_tool -c http://mirrors.163.com/.help/CentOS7-Base-163.repo
    sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    sudo chown root:root CentOS7-Base-163.repo
    sudo mv CentOS7-Base-163.repo /etc/yum.repos.d/

    #缓存服务器的软件信息到本地
    sudo yum makecache
    #net-tools.x86_64是为了安装ifconfig
    #ncurses-devel.x86_64是为了安装zsh
    sudo yum -y install $soft_list vim mysql-devel net-tools.x86_64 ncurses-devel.x86_64
    sudo yum -y groupinstall "Development Tools"
    
    setup_soft

    #清除缓存目录(/var/cache/yum)下的软件包及旧的headers
    sudo yum clean all
}

function setup {
    cd ~
    mkdir Workspace
    cd Workspace

    if is_centos
    then
        sudo yum -y install git $download_tool
    fi

    if is_ubuntu
    then
        sudo apt-get update
        sudo apt-get -y install git $download_tool
    fi

    git clone https://github.com/pylrichard/soft_config.git
    cd soft_config

    if is_centos
    then
        setup_centos
    fi

    if is_ubuntu
    then
        setup_ubuntu
    fi
}

case "$1" in
    'checkout_git_repo' )
        checkout_git_repo
        ;;
    'cp_mvn_config' )
        cp_mvn_config
        ;;
    'setup_zsh' )
        setup_zsh
        ;;
    'rm_src_dir' )
        rm_src_dir
        ;;
    'setup' )
    	setup
        ;;
    * )
        echo "Usage: $0 {setup | cp_mvn_config | rm_src_dir}" >&2
        ;;
esac
