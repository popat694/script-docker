#!/bin/bash

# Define variables
CONTAINER_NAME="my_container_name"

# Prompt the user to enter the local directory path
read -p "Enter the local directory path (e.g., /var/www/html/docker-project-first/): " LOCAL_DIR

# Prompt the user to enter the GitHub repository link
read -p "Enter the GitHub repository link: " GIT_REPO

# Check if the repository is private
PRIVATE_REPO=false
if [[ $GIT_REPO == *"github.com"* ]]; then
    echo "This is a GitHub repository. Is it private? (yes/no): "
    read IS_PRIVATE
    if [[ $IS_PRIVATE == "yes" ]]; then
        PRIVATE_REPO=true
        read -sp "Enter your GitHub personal access token: " GIT_TOKEN
        echo ""
    fi
fi

# Build the Docker image and pass the Git repository URL and token (if applicable) as build arguments
if [ "$PRIVATE_REPO" = true ]; then
    # Extracting the repository part
    # repo=$(echo "$GIT_REPO" | sed 's/.*github.com\/\([^\/]*\/[^\/]*\)\.git/\1/')
    # repo=$(echo "$GIT_REPO" | sed -E 's/.*github.com\/([^\/]+\/[^\/]+)(\.git)?/\1/')
    # Check if the URL ends with .git
    
    if [[ $GIT_REPO == *.git ]]; then
        repo=$(echo "$GIT_REPO" | sed 's/.*github.com\/\([^\/]*\/[^\/]*\)\.git/\1/')
    else
        repo=$(echo "$GIT_REPO" | sed -E 's/.*github.com\/([^\/]+\/[^\/]+)(\.git)?/\1/')
    fi

    REPO_WITH_TOKEN=https://$GIT_TOKEN@github.com/$repo.git
    
    echo $REPO_WITH_TOKEN
    # https://token@popat694/chat-app.  git
    docker build --build-arg GIT_REPO=$REPO_WITH_TOKEN -t my_react_app .
else
    docker build --build-arg GIT_REPO=$GIT_REPO -t my_react_app .
fi

# Run the Docker container
docker run -d --name $CONTAINER_NAME my_react_app

# Wait for the container to finish building the React project
docker exec $CONTAINER_NAME npm install
docker exec $CONTAINER_NAME npm run build

# Copy the build directory from the container to the local directory
docker cp $CONTAINER_NAME:/app/build/. $LOCAL_DIR

# Stop and remove the container
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
