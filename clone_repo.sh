#!/bin/bash

MAIN_DIR=$PWD
BRANCH_NAME='feat/docker-repo-change'
COMPANY="my_company"
FILE_TO_CHANGE="bitbucket-pipelines.yml"

REPO_LIST="my_first_repo \
           my_second_repo"


GIT_CLONE(){
    cd $MAIN_DIR
    for repo in $REPO_LIST; do
        git clone git@bitbucket.org:$COMPANY/$repo.git
    done
}


GIT_CHECKOUT_B(){
    for repo in $REPO_LIST; do
        cd $MAIN_DIR/$repo
        git checkout -b $BRANCH_NAME
        cd $MAIN_DIR
    done
}


REPLACE_STRING(){
    cd $MAIN_DIR
    find . -name $FILE_TO_CHANGE -type f -exec sed -i \
    's/google\/cloud-sdk:latest/gcr.io\/google.com\/cloudsdktool\/cloud-sdk:latest/g' \
    {} \;
}


GIT_ADD_COMMIT_PUSH(){
    for repo in $REPO_LIST; do
        cd $MAIN_DIR/$repo

        git add $FILE_TO_CHANGE && \
        git commit -m "google/cloud-sdk image repo changed" && \
        git push -u origin $BRANCH_NAME

        cd $MAIN_DIR
    done
}


### main code ###
GIT_CLONE
GIT_CHECKOUT_B
REPLACE_STRING
GIT_ADD_COMMIT_PUSH
