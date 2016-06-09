#!/bin/bash

# this is main function
function main {
  installTools
}

function skype {
  echo "--------------"
  echo "Starting install skype..."
  sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo apt-get install -y skype
  echo "--------------"
}

function java8 {
  echo "--------------"
  echo "Starting install java8"
  sudo add-apt-repository ppa:webupd8team/java
  sudo apt-get update
  sudo apt-get install -y oracle-java8-installer
  sudo apt-get install oracle-java8-set-default
  echo "--------------"
}

function vim {
  echo "--------------"
  echo "Starting install vim"
  sudo apt-get update
  sudo apt-get install vim
  echo "--------------"

  echo "Starting install tmux"
  sudo apt-get update
  sudo apt-get install tmux
  echo "--------------"
}

function ruby {
  echo "--------------"
  echo "Starting install RVM"
  sudo apt-get update
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  \curl -sSL https://get.rvm.io | bash -s stable

  source ~/.rvm/scripts/rvm
  rvm list known
  rvm install 2.3.0
  rvm use 2.3.0 --default
  echo "--------------"
}

function git {
  echo "--------------"
  echo "Starting install git"
  sudo apt-get update
  sudo apt-get install git
  git config --global user.name "khanhpn"
  git config --global user.email "phamkhanh90@gmail.com"
  echo "--------------"
}

function nginx {
  echo "--------------"
  echo "Starting install nginx"
  sudo apt-get install nginx
  echo "--------------"
}

function mysql {
  echo "--------------"
  echo "Starting install mysql"
  sudo apt-get update
  sudo apt-get install mysql-server
  sudo mysql_secure_installation
  sudo mysql_install_db
  echo "--------------"
}

function postgresql {
  echo "--------------"
  echo "Starting instal postgresql"
  sudo apt-get update
  sudo apt-get install postgresql postgresql-contrib
  sudo -i -u postgres
  echo "--------------"
}

function apache2 {
  echo "--------------"
  echo "Starting install Apache2"
  sudo apt-get update
  sudo apt-get install apache2
  sudo service apache2 restart
  echo "--------------"

  # Check if apache2 is running
  if pgrep "apache2" > /dev/null
  then
    echo "Running"
    sudo service apache2 stop
  else
    echo "Stopped"
    sudo service apache2 restart
  fi
  echo "--------------"
}

function update {
  echo "--------------"
  sudo apt-get update
  echo "--------------"
}

function docker {
  echo "--------------"
  echo "Install docker"
  wget -qO- https://get.docker.com/ | sh
  sudo usermod -aG docker $(whoami)

  echo "Beginning install docker composer"
  sudo apt-get -y install python-pip
  echo "Installing docker composer"
  sudo pip install docker-compose
  docker version
  echo "Finish install docker"
  echo "--------------"
}

function ssh {
  echo "--------------"
  echo "Starting install ssh"
  mkdir ~/.ssh
  chmod 0700 ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 0644 ~/.ssh/authorized_keys
  cd ~/.ssh
  ssh-keygen -t rsa -C "phamkhanh90@gmail.com"
  echo "--------------"
}

function checkProgramExist() {
  if [ ! $(which $1) ]; then
    echo "$2 is not installed, can't continue."
    $3
  else
    echo "$2 was installed"
  fi
}

function stopTools {
  while true
  do
    PS3="Please choice service which you want to stop: "
    options=("skype" "apache2" "nginx" "mysql" "postgresql" "docker" "teamviewer" "redis" "quit")
    select shuttle in "${options[@]}"
    do
      case $shuttle in
        "skype")
          killall -9 skype
          break
          ;;
        "apache2")
          sudo service apache2 stop
          break
          ;;
        "nginx")
          sudo service nginx stop
          break
          ;;
        "mysql")
          sudo service mysql stop
          break
          ;;
        "postgresql")
          sudo service postgresql stop
          break
          ;;
        "docker")
          sudo service docker stop
          break
          ;;
        "teamviewer")
          sudo teamviewer --daemon stop
          break
          ;;
        "redis")
          sudo service redis-server stop
          sudo service bluetooth stop
          break
          ;;
        quit)
          echo "Thank you..."
          exit 0
          ;;
        *) echo invalid option;;
      esac
    done
  done
}

function installTools {
  while true
  do
    PS3="Please enter your choice to install softweare you need: "
    options=("skype" "java8" "vim" "apache2" "ruby" "git" "nginx" "mysql" "postgresql" "update" "docker" "ssh" "stop_service" "quit")
    select shuttle in "${options[@]}"
    do
      case $shuttle in
        "skype")
          checkProgramExist "skype" "Skype" skype
          break
          ;;
        "java8")
          checkProgramExist "java8" "Java8" java8
          break
          ;;
        "vim")
          checkProgramExist "vim" "Vim" vim
          break
          ;;
        "apache2")
          checkProgramExist "apache2" "Apache2" apache2
          break
          ;;
        "ruby")
          checkProgramExist "ruby" "Ruby" ruby
          break
          ;;
        "git")
          checkProgramExist "git" "Git" git
          break
          ;;
        "nginx")
          checkProgramExist "nginx" "Nginx" nginx
          break
          ;;
        "mysql")
          checkProgramExist "mysql" "Mysql" mysql
          break
          ;;
        "postgresql")
          checkProgramExist "postgresql" "Postgresql" postgresql
          break
          ;;
        "docker")
          checkProgramExist "docker" "Docker" docker
          break
          ;;
        "ssh")
          checkProgramExist "ssh", "SSH", ssh
          break
          ;;
        "stop_service")
          stopTools
          break
          ;;
        "update")
          update
          break
          ;;
        quit)
          echo "Thank you..."
          exit 1
          ;;
        *) echo invalid option;;
      esac
    done
  done
}

# program will execute this function firstly
main
