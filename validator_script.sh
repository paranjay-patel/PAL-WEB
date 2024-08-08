#!/bin/bash

# Function to check if PR title contains a JIRA ticket reference
check_jira_ticket_reference() {
    local pr_title="$1"
    if [[ "$pr_title" =~ (?i)([a-z]+-[0-9]+) ]]; then
        jira_ticket="${BASH_REMATCH[1]}"
        echo "PR title contains JIRA ticket reference: $jira_ticket"
    else
        echo "PR title does not contain a JIRA ticket reference."
        exit 1
    fi
}

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

# Function to check if PR description is provided and contains the JIRA ticket reference
check_pr_description() {
    local pr_description="$1"
    if [[ -z "$pr_description" ]]; then
        echo "PR description is not provided."
        exit 1
    else
        echo "PR description is provided."
    fi

    # Check if JIRA ticket reference is in the description and matches the one in the title
    if [[ "$pr_description" =~ ([A-Z]+-[0-9]+) ]]; then
        jira_ticket_desc="${BASH_REMATCH[1]}"
        echo "PR description contains JIRA ticket reference: $jira_ticket_desc"
        if [[ "$jira_ticket" != "$jira_ticket_desc" ]]; then
            echo "JIRA ticket reference in title ($jira_ticket) does not match the one in description ($jira_ticket_desc)."
            exit 1
        fi
    else
        echo "PR description does not contain a JIRA ticket reference."
        exit 1
    fi

    # Ensure the description is more than just the JIRA ticket
    if [[ "${#pr_description}" -le "${#jira_ticket_desc}" ]]; then
        echo "PR description is not detailed enough."
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
echo "PR validation checks completed successfully."
