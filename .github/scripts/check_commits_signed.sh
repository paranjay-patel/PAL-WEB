#!/bin/bash

# Function to verify that all commits are signed
check_commits_signed() {
    local pr_number="$1"
    local repo="$2"
    local commits=$(gh pr view "$pr_number" --repo "$repo" --json commits --jq '.commits[].oid')

    for commit in $commits; do
        local commit_info=$(gh api repos/$repo/git/commits/$commit)
        local verification_status=$(echo "$commit_info" | jq -r '.verification.verified')
        local commit_message=$(echo "$commit_info" | jq -r '.message')
        local commit_author=$(echo "$commit_info" | jq -r '.author.name')
        local commit_date=$(echo "$commit_info" | jq -r '.author.date')

        if [[ "$verification_status" != "true" ]]; then
            echo "Commit $commit is not signed."
            echo "  Commit message: $commit_message"
            echo "  Author: $commit_author"
            echo "  Date: $commit_date"
            exit 1
        else
            echo "Commit $commit is signed."
            echo "  Commit message: $commit_message"
            echo "  Author: $commit_author"
            echo "  Date: $commit_date"
        fi
    done
    echo "All commits are signed."
}

# Get PR details
PR_NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
PR_TITLE=$(jq --raw-output .pull_request.title "$GITHUB_EVENT_PATH")
PR_DESCRIPTION=$(jq --raw-output .pull_request.body "$GITHUB_EVENT_PATH")
REPO_FULL_NAME=$(jq --raw-output .repository.full_name "$GITHUB_EVENT_PATH")

# Log PR details
echo "PR Number: $PR_NUMBER"
echo "PR Title: $PR_TITLE"
echo "Repository: $REPO_FULL_NAME"
echo "PR Description: $PR_DESCRIPTION"

# Perform checks
check_commits_signed "$PR_NUMBER" "$REPO_FULL_NAME"

# Output status report
echo "PR validation checks for signed commits completed successfully."
