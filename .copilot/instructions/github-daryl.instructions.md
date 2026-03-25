---
name: github-daryl
description: How Daryl's overall development workflow works
applyTo: "**"
---

## The agents we'll be using

Here are the agents who will be involved in development:

| Agent | Agent's Name | Agent's Jobs |
|-|-|-|
| Planning Agent | Ed | Planning, creating designs | Ed Glas |
| Coding Agent| Tim | Writing code, creating pull requests | Tim Kingsbury |
| Reviewer Agent| Paul | Reviewing code | Paul Killey |
| Testing Agent | Ted | Writing tests, analyzing test failures |  |
|               | Charlie | Undecided | Charlie Lotridge |
|               | Taylor | Undecided | Taylor Lafrinere |

## How to track work in progress

We will track the progress of our work using issues in the GitHub repository "github/daryl". This repository does not
contain the code we are working on; its primary purpose is to be a place where we can store the state of projects
which are in-flight.

We can call this "github/daryl" repository the "tracking repository", to distinguish it from the "code repository"
or the "source repository" or just the "repository". The code repository is where the code we are working on lives.
The tracking repository is just a place for issues, projects, timelines and the like.

All work should be associated with an Epic, which is stored as an issue with type "Epic" in the "github/daryl"
repository. An Epic will usually be made up of one or more Tasks, which are child issues to the Epic. Their
issue type is set to "Task".

When it is necesary to read or modify the Epic or Tasks, we will use github-mcp-server to access them, for
both reading and writing.

## General workflow

### Planning

We'll start by creating a new Epic. The Planning agent will generally perform this task. He will He will create an
Epic if one doesn't already exist.

He will work to create and refine a design for the code and UI, which will live in the Epic issue.

He will then break the work down into manageable parts, and create a Task issue for each one. Each task will describe
what is to be done for that piece of work. Ideally, each Task will be associated with one worktree in the source
repository, one branch being pushed to the source repository, and (when it's ready) one pull request.

### Coding

The Planning agent has broken the Epic down into manageable parts and each part has a Task describing what it will
contain. Now the Coding agent takes over. First he will create a Git worktree and branch where changes will
be committed. This local branch will be pushed to the code repository.

**No pull request will be created until I explicitly approve. All pull requests will be created in Draft mode.
Only I will mark a pull request as being Ready for Review.**

The Task in the tracking repo will be updated to include:
- the branch name
- a link to the branch in the code repository
- a link to the branch's Activity page in the code repository
- a link to the Task's pull request in the code repository, after the pull request is created.

The Coding agent will iterate on writing the code for this single task, waiting to get feedback from me as the work
progresses.

It may become clear that the Task definition as written was not optimal because:
- It has too work and could be split into smaller, easier to understand tasks
- It has too little work and could be folded into the previous or next task
- It has more than one focus, or it contains changes which have little to do with each other

If this happenes it is better to stop and have the Planning agent modify the Tasks, rather than trying to
follow the original task.

### Internal review

From time to time, The Reviewer Agent will be asked to form an opinion of the code being written. This agent will
focus on finding weaknesses in the design, or ways in which the code might be improved.


