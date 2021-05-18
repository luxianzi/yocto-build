#!/bin/sh

REPO_DIRECTORY=$(cat build_directory)
REPO_CONFIGURE_SCRIPT=setup-environment
REPO_URL=https://github.com/luxianzi/imx-manifest.git
REPO_BRANCH=imx-linux-gatesgarth
REPO_CONFIGURATION=imx-5.10.9-1.0.0.xml

if [ ! -f ~/"$REPO_DIRECTORY/$REPO_CONFIGURE_SCRIPT" ]; then
	curl https://storage.googleapis.com/git-repo-downloads/repo > ~/repo
	chmod a+x ~/repo
	cd ~/"$REPO_DIRECTORY"
	yes | ~/repo --color=always init -u "$REPO_URL" -b "$REPO_BRANCH" -m "$REPO_CONFIGURATION"
	~/repo sync
else
	echo "$HOME/$REPO_DIRECTORY" already exists, skipping the \
		initialization of BSP repo
fi
