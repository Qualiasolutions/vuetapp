# CodeRabbit Integration Guide

This document explains how to use CodeRabbit for code analysis in this project.

## What is CodeRabbit?

CodeRabbit is an AI-powered code review tool that helps improve code quality by providing automated feedback on your code through GitHub pull requests or VS Code extension.

## Setup Instructions

CodeRabbit works in two main ways:

### Option 1: GitHub App (Recommended for Teams)

1. Visit [CodeRabbit on GitHub Marketplace](https://github.com/marketplace/coderabbitai)
2. Set up a free trial or choose a plan
3. Install the app to your repository
4. Add your API key to GitHub secrets
5. Create a workflow file at `.github/workflows/coderabbit.yml` 

### Option 2: VS Code Extension (For Local Development)

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "CodeRabbit"
4. Install the extension
5. Configure the extension with your API key

## Using CodeRabbit with GitHub

Once you've set up CodeRabbit as a GitHub App:

1. Create a pull request as usual
2. CodeRabbit will automatically review your code
3. View suggestions and comments directly in the PR
4. Reply to CodeRabbit's comments to get more information

## GitHub Workflow Configuration

Here's a sample workflow configuration for `.github/workflows/coderabbit.yml`:

```yaml
name: CodeRabbit Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  coderabbit-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Run CodeRabbit analysis
        uses: coderabbitai/ai-pr-reviewer@latest
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          OPENAI_API_KEY: ${{ secrets.CODERABBIT_API_KEY }}
        with:
          debug: false
          review_simple_changes: false
          review_comment_lgtm: false
```

## Support

For more information about CodeRabbit, visit [the CodeRabbit website](https://coderabbit.ai/) 