#!/bin/bash
# Script used to create Environment 

# Does three things:
# - 


CLUSTER_NAME=${1}
SUDO_PASS=${2}

FILE_NAME=$CLUSTER_NAME-config

export KUBECONFIG=~/.kube/$FILE_NAME

echo $KUBECONFIG

make CLUSTER_NAME=$CLUSTER_NAME .create-eks-cluster

# echo $KUBECONFIG



