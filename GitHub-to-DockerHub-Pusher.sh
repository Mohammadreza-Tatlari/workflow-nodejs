#!/bin/bash

# Checking whether Git and Docker Packages are available:
command -v git > /dev/null 2>&1 || { echo >&2 "git is required but not installed. Please install it"; exit 1; }
command -v docker > /dev/null 2>&1 || { echo >&2 "docker is required but not found. Please install docker first"; exit 1; }

usage(){
    echo "Usage: $0 <Github_Repository_URL> <Docker_Hub_Repository_Name> [Docker_Tag]"
    echo "  <GitHub_Repository_URL>: The URL of the GitHub repository to download (e.g., https://github.com/user/repo)."
    echo "  <Docker_Hub_Repository_Name>: The name of the repository on Docker Hub (e.g., username/my-image)."
    echo "  [Docker_Tag]: (Optional) The tag for the Docker image. Defaults to 'latest'."
    exit 1
}

#checking the correctness of arguments
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    usage
fi

#Set Variables from command-line arguments
github_repo_url=$1
docker_hub_repo=$2
docker_version=${3:-"latest"} #default tag is "latest"


echo "the github URL: $github_repo_url"
echo "the DockerHub repo is $docker_hub_repo" 
echo "the select version is $docker_version"


if [ -z "$DOCKER_USERNAME" ]; then
    read -p "please insert username of your docker account: " DOCKER_USERNAME
    
    if [ ! -z "$DOCKER_USERNAME" ]; then
        read -s -p "please insert password of $DOCKER_USERNAME docker account: " DOCKER_PASSWORD
        echo "processing..."
    fi
fi
#DOCKER_USERNAME
#DOCKER_PASSWORD


#Error Handler 
error_handler(){
    local error_message="$1"
    echo Error: "$error_message" >&2
    # Clean up: Remove the temporary directory if it exists
    if [ -d "temp_repo" ]; then
    rm -rf "temp_repo"
    fi
    exit 1
}

# checking if any directory with name 'temp_repo' exists and if so it will be overwritten
if [ -d "temp_repo" ]; then
    read -p "Directory 'temp_repo' already exists. Do you want to overwrite it? (y/N) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Removing existing temp_repo directory..."
        rm -rf "temp_repo" || echo "Failed to Remove the existing temp_repo directory (Internal function acitvated)"
    else
        echo "Skipping Removal of existing temp_repo directory"
    fi 
fi


# 1. download the Github repository
echo "Downloading GitHub repository: $github_repo_url"
# error_handler is used instead of echo
git clone "$github_repo_url" "temp_repo" || echo "Failed to clone the Github repository ";
cd "temp_repo"; echo -e "changing directory to: \n "$PWD" " || echo "Failed to change directory after Clonization is completed.";


# 2. Buld the Docker image
echo "Building Docker Image: $docker_hub_repo:$docker_version"
docker build . -t "$docker_hub_repo$docker_version" || echo "failed to push the Docker image to Dockerhub."

# 3. Log in to DockerHub
echo "Logging in to DockerHub..."
# docker login -u "${echo -n "$DOCKER_USERNAME"}" -p "$(echo -n "$DOCKER_PASSWORD")" || echo "Failed to log in to Dockerhub. Make sure DOCKER_USERNAME and DOCKER_PASSWORD are set as environment variables."
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD" || echo -e " /n Failed to log in to Dockerhub, make sure username and password are correct."

# 4. Tagging the Docker Image file
echo "Tagging the Dockerfile with the name "$docker_hub_repo$docker_version" "
docker tag "$docker_hub_repo$docker_version" "$DOCKER_USERNAME/$docker_hub_repo$docker_version"

# 5. Publish the Docker image to Docker Hub
echo "Publishing Docker image to Docker Hub: $docker_hub_repo:$docker_version"
docker push "$DOCKER_USERNAME/$docker_hub_repo$docker_version" || echo "Failed to push the Docker Image to Docker hub."


# # . Clean up: Remove the temporary repository directory
# echo "Cleaning up temporary files..."
# cd .. # Go back up one directory before deleting
# rm -rf "temp_repo" || echo "Warning: Failed to remove temporary directory 'temp_repo'.  You may need to remove it manually."

echo "Successfully published Docker image: $docker_hub_repo:$docker_version"
echo -e" \n The Docker Name was:"$DOCKER_USERNAME" \n the Dockerhub Repository was:"$" \n the github the data is fetched is "$github_repo_url" "
exit 0
