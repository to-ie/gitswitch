# Gitswitch
This script helps with users who have multiple GitHub profiles and require to switch between them on a regular basis.  

## Requirements and assumptions
This script is for Ubuntu (or other Linux distributions) users. We assume that you already have GitHub CLI installed (if not, check [this page](https://cli.github.com/manual/installation) out) and that you are using [Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) to connect to your GitHub account. 

Before installing Gitswitch, you might want to have the following info ready, for each account: 
- A nickname for the account (ie: 'work')
- the GitHub username
- the email address linked to the account
- the personal access key for the GitHub account (generate one [here](https://github.com/settings/tokens))

## Install the script
To install Gitswitch, follow the instructions below. 

Let's keep things clean. Head over to your Desktop:
```
cd ~/Desktop
```

Clone this repository:
```
git clone https://github.com/to-ie/gitswitch
```

and launch the setup:
```
bash ~/Desktop/gitswitch/switch.sh
```

Follow the configuration instructions provided by the script. 
<br>Note: you will need some basic information about your accounts (check the pre-requisit section above).

Once you have installed and configured gitswitch, let's clean up after ourselves:
```
rm -r ~/Desktop/gitswitch
```

## Usage
Once you have installed and configured gitswitch, simply type `gitswitch` in your terminal. That's it! 👍