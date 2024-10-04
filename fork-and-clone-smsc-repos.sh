#!/bin/bash

# Function to get the token and username
get_credentials() {
    read -p "Enter your GitHub username: " GITHUB_USER
    read -p "Enter your GitHub personal access token: " TOKEN
}

# Check the command line arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <destination_directory>"
    exit 1
fi

# Get the destination directory from the arguments
DESTINATION="$1"

# List of repositories (user/repo)
repos=(
    "paicbd/smsc-management-fe"
    "paicbd/ss7-client-module"
    "paicbd/smsc-management-be"
    "paicbd/http-server-module"
    "paicbd/http-client-module"
    "paicbd/smpp-server-module"
    "paicbd/smpp-client-module"
    "paicbd/smsc-orchestrator"
    "paicbd/smsc-retries-module"
    "paicbd/db-insert-data"
    "paicbd/smsc-utils"
    "paicbd/jss7"
    "paicbd/jsmpp"
    "paicbd/sctp"
)

# Get the token and username
get_credentials

# Create the destination directory if it doesn't exist
mkdir -p "$DESTINATION"

# Store the URLs of the forks (original and fork)
forked_urls=()

echo "---------------------------------"
echo "forks started"
echo "---------------------------------"

# Create forks for each repository
for repo in "${repos[@]}"; do
    # URL to create the fork using the GitHub API
    fork_url="https://api.github.com/repos/$repo/forks"

    status_code=$(curl -s -X POST -H "Authorization: token $TOKEN" --write-out %{http_code} --output /dev/null "$fork_url")

    if [ "$status_code" -eq 202 ]; then
        echo "Fork created for $repo."
    else
        echo "Error forking $repo: status code $status_code"
    fi

    repo_name=$(basename "$repo")  # Get the repository name
    forked_urls+=("https://github.com/$repo.git https://github.com/$GITHUB_USER/$repo_name.git")
done

echo "---------------------------------"
echo "Waiting for forks to complete..."
sleep 10  # Wait for 10 seconds, adjust as necessary

echo "\n---------------------------------"
echo "cloning started"
# Clone each fork using the stored URLs
for urls in "${forked_urls[@]}"; do
    original_repo_url=$(echo $urls | cut -d' ' -f1)
    forked_repo_url=$(echo $urls | cut -d' ' -f2)
    repo_name=$(basename "$forked_repo_url" .git)  # Get the repository name

    git clone "$forked_repo_url" "$DESTINATION/$repo_name"
    cd "$DESTINATION/$repo_name" || continue

    # Add the original remote (upstream)
    git remote add upstream "$original_repo_url"
    echo "Remote 'upstream' added for $repo_name."

    # Ask the user if they want to fetch and merge changes from the original repository
    read -p "Do you want to fetch and merge changes from the original repository? (yes/no): " fetch_merge
    fetch_merge=$(echo "$fetch_merge" | tr '[:upper:]' '[:lower:]')
    if [[ "$fetch_merge" == "yes" || "$fetch_merge" == "y" ]]; then
        git fetch upstream
        git merge upstream/main  # Change 'main' if necessary
        
        # Ask the user if they want to push changes to their fork
        read -p "Do you want to push these changes to your fork? (yes/no): " push_changes
        push_changes=$(echo "$push_changes" | tr '[:upper:]' '[:lower:]')
        if [[ "$push_changes" == "yes" || "$push_changes" == "y" ]]; then
            git push origin main  # Change 'main' if necessary
            echo "Changes pushed to your fork."
        else
            echo "Changes not pushed to your fork."
        fi
    fi

    # Go back to the previous directory
    cd - || exit
done
echo "---------------------------------"

echo "All repositories have been processed."
