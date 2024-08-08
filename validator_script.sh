#!/bin/bash

# Function to check if PR title contains a JIRA ticket reference
check_jira_ticket_reference() {
    local pr_title="$1"
    if [[ "$pr_title" =~ [A-Z]+-[0-9]+ ]]; then
        echo "PR title contains a JIRA ticket reference."
    else
        echo "PR title does not contain a JIRA ticket reference."
        exit 1
    fi
}

# Function to verify that all commits are signed
check_commits_signed() {
    local pr_number="$1"
    local repo="$2"
    local commits=$(gh pr view "$pr_number" --repo "$repo" --json commits --jq '.commits[].commit.oid')

    for commit in $commits; do
        local verification_status=$(gh api repos/$repo/git/commits/$commit | jq -r '.verification.verified')
        if [[ "$verification_status" != "true" ]]; then
            echo "Commit $commit is not signed."
            exit 1
        fi
    done
    echo "All commits are signed."
}

# Function to check if PR description is provided
check_pr_description() {
    local pr_description="$1"
    if [[ -z "$pr_description" ]]; then
        echo "PR description is not provided."
        exit 1
    else
        echo "PR description is provided."
    fi
}

# Get PR details
PR_NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
PR_TITLE=$(jq --raw-output .pull_request.title "$GITHUB_EVENT_PATH")
PR_DESCRIPTION=$(jq --raw-output .pull_request.body "$GITHUB_EVENT_PATH")
REPO_FULL_NAME=$(jq --raw-output .repository.full_name "$GITHUB_EVENT_PATH")

# Perform checks
check_jira_ticket_reference "$PR_TITLE"
check_commits_signed "$PR_NUMBER" "$REPO_FULL_NAME"
check_pr_description "$PR_DESCRIPTION"

# Output status report
echo "PR validation checks completed successfully."
