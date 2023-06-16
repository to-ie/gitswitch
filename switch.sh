#!/bin/bash
# last update: 20230616

# Cosmetics
GREEN='\033[0;32m' 
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'        # No Color


# Check if Github is currently setup. 
# If it is not, close gitswitch.
if  test -e ~/.gitconfig; then
</dev/tty
else
  echo
  printf "${BLUE}Notice:${NC}\n"
  printf "${BLUE}It looks like GitHub cli is not currently setup.${NC}\n"
  printf "${BLUE}Make sure to install it and then launch gitswitch again.${NC}\n"
  exit
fi


# Check if gitswitch is correctly configured. 
# If not, configure. If it is, switch.

# gitswitch is corretly configured
if  test -e ~/.gitswitch/gscurrent; then 
  # require prompt
  echo
  current=$(cat ~/.gitswitch/gscurrent)

  # printf "${BLUE}You are about to switch git profile.${NC}\n"
  printf "${BLUE}You are currently logged in as "
  cat ~/.gitswitch/${current}
  printf "${NC}"
  echo
  read -p "Press Enter to switch profiles" </dev/tty

  # if profile 1, switch to profile 2 
  if grep -q profile1 ~/.gitswitch/gscurrent; then
    cp ~/.gitswitch/git-credentials/profile2/.gitconfig ~/.gitconfig 
    cp ~/.gitswitch/git-credentials/profile2/.git-credentials ~/.git-credentials 
    echo profile2 > ~/.gitswitch/gscurrent
    profile2=$(cat ~/.gitswitch/profile2) 
    printf "${GREEN}You are now logged in as ${profile2}.${NC}\n"
    echo
    exit
  fi

  # if profile 2, switch to profile 1
  if grep -q profile2 ~/.gitswitch/gscurrent; then
    cp ~/.gitswitch/git-credentials/profile1/.gitconfig ~/.gitconfig 
    cp ~/.gitswitch/git-credentials/profile1/.git-credentials ~/.git-credentials 
    echo profile1 > ~/.gitswitch/gscurrent
    profile1=$(cat ~/.gitswitch/profile1)
    printf "${GREEN}You are now logged in as ${profile1}.${NC}\n"
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
  printf "${BLUE}Let's setup the first profile.${NC}\n"
  read -p "What do you want to call this profile? (chose something that makes sense to you) " profile1
  mkdir ~/.gitswitch/git-credentials/profile1
  read -p "What is your GitHub username for this account? " p1name
  read -p "What is the email address associated to this GitHub account? " p1email
  read -p "Finally, what is the Personal Access Key for this account? " p1accesskey

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
  printf "${BLUE}Let's setup the second profile. ${NC}\n"
  read -p "What do you want to call this profile? (chose something that makes sense to you) " profile2
  mkdir ~/.gitswitch/git-credentials/profile2
  read -p "What is your GitHub username for this account? " p2name
  read -p "What is the email address associated to this GitHub account? " p2email
  read -p "Finally, what is the Personal Access Key for this account? " p2accesskey

  # create config files for profile 2
  echo "[user]" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "  name = ${p2name}" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "  email = ${p2email}" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "[credential]" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "  helper = store" >> ~/.gitswitch/git-credentials/profile2/.gitconfig
  echo "https://${p2name}:${p2accesskey}@github.com" >> ~/.gitswitch/git-credentials/profile2/.git-credentials
  echo "${profile2}" > ~/.gitswitch/profile2
  printf "${GREEN}Perfect, the second profile is created.${NC}\n"
  echo
  echo

  # set current profile and gscurrent file
  printf "${BLUE}We will now setup ${profile1} as your current profile.${NC}\n"
  touch ~/.gitswitch/gscurrent
  echo "profile1" > ~/.gitswitch/gscurrent
  cp ~/.gitswitch/git-credentials/profile1/.gitconfig ~/.gitconfig 
  cp ~/.gitswitch/git-credentials/profile1/.git-credentials ~/.git-credentials 
  printf "${GREEN}${profile1} is now the current profile.${NC}\n"

  # download gitswitch script from github and move it to ~/.gitswitch
  printf "${BLUE}Hold on while we do some final bits of configuration...${NC}\n"
  cd ~/.gitswitch/
  git clone https://github.com/to-ie/gitswitch
  mv ~/.gitswitch/gitswitch/switch.sh ~/.gitswitch/switch.sh
  rm -r ~/.gitswitch/gitswitch/

  # setup alias 
  echo "alias gitswitch='bash ~/.gitswitch/switch.sh'" >> ~/.bashrc
  printf "${GREEN}Alias set in .bashrc.${NC}\n"

  # all done
  printf "${GREEN}You can now switch GitHub profiles by typing 'gitswitch' in a new terminal.${NC}\n"

fi
