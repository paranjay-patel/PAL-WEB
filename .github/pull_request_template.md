## Description

<!-- Describe the purpose and context of this PR.
e.g. Fixes #[issue number] -->

**JIRA Ticket Link:** [TICKET](url link)

## Type of Change

- [ ] Bug Fix
- [ ] New Feature
- [ ] Enhancement
- [ ] Automation Tests
- [ ] Unit Tests
- [ ] Documentation
- [ ] Other (please describe)

## Checklist

<!-- Mark the appropriate options by adding an "X" within the square brackets for each item. -->

- **I have thoroughly reviewed and tested my changes.**
  - [ ] YES 
  - [ ] NO 
  - [ ] N/A

- **I have run all the existing automation and unit tests, and they are all passing.**
  - [ ] YES
  - [ ] NO 
  - [ ] N/A

- **I have checked for any console errors or warnings.**
  - [ ] YES 
  - [ ] NO 
  - [ ] N/A

- **I have tested this PR on multiple devices/browsers.**
  - [ ] YES 
  - [ ] NO 
  - [ ] N/A

- **I have checked that this PR does not introduce any new warnings.**
  - [ ] YES 
  - [ ] NO 

- **I have checked that the PR does not contain any commented out code.**
  - [ ] YES 
  - [ ] NO 

## Visual Feature (if applicable)

<!-- Add screenshots or videos in this section. -->

- [ ] This PR introduces visual changes.
- [ ] I have attached images or videos that illustrate the visual changes for easy verification.

### Checklist for Visual Changes 

- [ ] Dark Mode Implemented
- [ ] Light Mode Implemented
- [ ] All copy is localized.

## Test Plan for QA

<!-- Create a test plan for the QA. See example TP1 below. 
The test plan includes clear, step-by-step instructions on how to test this PR.
Provide any specific test data or environment setup requirements documented here.
QA will use this test plan to create automation tests. -->

**TP1: Test Login Flow**
1. Navigate to the settings screen.
2. Open advanced settings screen
3. Change temperature settings from C to F
4. Navigate back to the main control screen
5. Verify that all temperature values are in F
   - QA validated: [ ]