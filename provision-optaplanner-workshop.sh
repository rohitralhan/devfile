#!/bin/sh

PROJECT_NAME="optaplanner2-workshop-2"

echo "Creating project: $PROJECT_NAME"
oc new-project $PROJECT_NAME --display-name="OptaPlanner Workshop" --description="OptaPlanner Workshop"

# Delete limits on RHPDS, until we figure out how to properly configure the defaults.
# oc delete limits/$PROJECT_NAME-core-resource-limits -n $PROJECT_NAME

echo "Installing CodeReady Workspaces Operator."
cat optaplanner-workshop-operator-group.yaml | sed -e "s/namespace-placeholder/$PROJECT_NAME/g" | oc apply -n $PROJECT_NAME -f -
cat codeready-workspaces-operator-sub.yaml | sed -e "s/namespace-placeholder/$PROJECT_NAME/g" | oc apply -n $PROJECT_NAME -f - 

# This seems to be needed to allow the API of Che resources/CRDs to be available in the cluster.
echo "Wait for the Operator to be installed."
sleep 10

# Create Che Cluster
echo "Creating CodeReady Workspaces cluster."
cat checluster.yaml | sed -e "s/namespace-placeholder/$PROJECT_NAME/g" | oc apply -n $PROJECT_NAME -f -

echo "Provisioning completed."
