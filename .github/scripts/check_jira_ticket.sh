#!/bin/bash

# Function to check if PR title contains a JIRA ticket reference (case-insensitive)
check_jira_ticket_reference() {
    local pr_title="$1"
    if [[ "$pr_title" =~ ^([A-Z]+-[0-9]+):\ (.+)$ ]]; then
        jira_ticket="${BASH_REMATCH[1]}"
        title_message="${BASH_REMATCH[2]}"
        jira_ticket_uppercase=$(echo "$jira_ticket" | awk '{print toupper($0)}')
        echo "PR title contains JIRA ticket reference: $jira_ticket_uppercase"
        echo "PR title message: $title_message"
    else
        echo "PR title does not contain a proper JIRA ticket reference. please add a JIRA ticket reference in proper format. ex. HT-211: Modified info.txt "
        exit 1
    fi
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
check_jira_ticket_reference "$PR_TITLE"
check_commits_signed "$PR_NUMBER" "$REPO_FULL_NAME"
check_pr_description "$PR_DESCRIPTION"

# Output status report
echo "PR validation checks for JIRA ticket referance completed successfully."
