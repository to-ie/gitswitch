#!/bin/bash

# This script helps with users who have multiple GitHub profiles and require to 
# switch between them on a regular basis.  
# Known limitations: 
##  - Needs user to be authenticating to GitHub via Personal Access Tokens 
#   - only works for 2 profiles at this stage. 
#
# Script written by toie for Ubuntu users.
# Last update: 20230616

# Cosmetics
GREEN='\033[0;32m' 
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'        # No Color


# Check if Github is currently setup. 
# If it is not, close gitswitch.
if  cat ~/.git-credentials; then > /dev/null 
else
  echo
  printf "${BLUE}Notice:${NC}\n"
  printf "${BLUE}It looks like GitHub cli is not currently setup.${NC}\n"
  printf "${BLUE}Make sure to install it and then launch gitswitch again.${NC}\n"
  exit
fi


# Check if gitswitch is correctly configured. 
# If not, configure. If it is, switch.

# gitswitch is corrctly configured
if  cat ~/.gitswitch/gscurrent; then > /dev/null 
  # require prompt
  echo
  printf "${BLUE}You are about to switch git profile.${NC}\n"
  printf "${BLUE}You are currently logged in as${NC}\n"
  cat ~/.gitcurrent
  echo
  read -p "Press Enter to switch profiles" </dev/tty

  # if profile 1, switch to profile 2 
  if grep -q profile1 ~/.gitswitch/gscurrent; then
    cp ~/.gitswitch/git-credentials/profile2/.gitconfig ~/.gitconfig 
    cp ~/.gitswitch/git-credentials/profile2/.git-credentials ~/.git-credentials 
    echo profile2 > ~/.gitswitch/gscurrent
    cat ~/Documents/git-switcher/profile2 $profile2
    printf "${GREEN}You are now logged in as ${profile2}${NC}\n"
    echo
    exit
  fi

  # if profile 2, switch to profile 1
  if grep -q profile2 ~/.gitswitch/gscurrent; then
    cp ~/.gitswitch/git-credentials/profile1/.gitconfig ~/.gitconfig 
    cp ~/.gitswitch/git-credentials/profile1/.git-credentials ~/.git-credentials 
    echo profile1 > ~/.gitswitch/gscurrent
    cat ~/Documents/git-switcher/profile2 $profile1
    printf "${GREEN}You are now logged in as ${profile1}${NC}\n"
    echo
    exit
  fi

# gitswitch is not properly configured
else
  # start configurations
  echo
  printf "${BLUE}Notice:${NC}\n"
  printf "${BLUE}It looks like gitswitch has not been configured yet.${NC}\n"
  printf "${BLUE}Let's take a second and do this.${NC}\n\n"

  # Create directoried
  mkdir ~/.gitswitch
  mkdir ~/.gitswitch/git-credentials

  # Create profile 1
  printf "${BLUE}Let's setup the first account. Answer the questions below:${NC}\n"
  read -p "What is the name of your first profile? " $profile1
  mkdir ~/.gitswitch/git-credentials/profile1
  read -p "What is the username of the GitHub account? " p1name
  read -p "What is the email address associated to the GitHub account? " p1email
  read -p "What is the Personal Access Key of this account? " p1accesskey

  # create config files for profile 1
  echo "[user]" >> ~/.gitswitch/git-credentials/profile1/.gitconfig
  echo "  name = ${p1name}" >> ~/.gitswitch/git-credentials/profile1/.gitconfig
  echo "  email = ${p1email}" >> ~/.gitswitch/git-credentials/profile1/.gitconfig
  echo "[credential]" >> ~/.gitswitch/git-credentials/profile1/.gitconfig
  echo "  helper = store" >> ~/.gitswitch/git-credentials/profile1/.gitconfig
  echo "https://${p1name}:${p1accesskey}@github.com" >> ~/.gitswitch/git-credentials/profile1/.git-credentials
  echo "${profile1}" > ~/.gitswitch/profile1
  printf "${GREEN}Perfect, the first profile is created.${NC}\n"

  # Create profile 2
  printf "${BLUE}Let's setup the second account. Answer the questions below:${NC}\n"
  read -p "What is the name of your second profile? " $profile2
  mkdir ~/.gitswitch/git-credentials/profile2
  read -p "What is the username of the GitHub account? " p2name
  read -p "What is the email address associated to the GitHub account? " p2email
  read -p "What is the Personal Access Key of this account? " p2accesskey

  # create config files for profile 2
  echo "[user]" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "  name = ${p1name}" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "  email = ${p1email}" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "[credential]" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "  helper = store" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "https://${p1name}:${p1accesskey}@github.com" >> ~/.gitswitch/git-credentials/profile2/.git-credentials
  echo "${profile2}" > ~/.gitswitch/profile2
  printf "${GREEN}Perfect, the second profile is created.${NC}\n"

  # setup ~/.gitswitch/gscurrent
  # set current profile
  touch ~/.gitswitch/gscurrent
  echo "profile1" > ~/.gitswitch/gscurrent
  cp ~/.gitswitch/git-credentials/profile1/.gitconfig ~/.gitconfig 
  cp ~/.gitswitch/git-credentials/profile1/.git-credentials ~/.git-credentials 

  # download gitswitch script from github(?) and move it to ~/.gitswitch
  # setup alias 

fi
