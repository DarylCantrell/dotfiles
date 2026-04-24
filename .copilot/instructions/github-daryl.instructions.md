---
name: github-daryl
description: How Daryl's overall development workflow works
applyTo: "**"
---

## Common abbreviations and shorthand

- **repo** → repository
- **org** → organization
- **PR** → pull request

## Repositories we use

"Public repository" means a repository which other team members can see. It's not "public to the world", but others
can see the issues and code. Terms like "public issues" and "public pull requests" refer to issues and pull requests
in a public repo.

Here are the most common public repos where we check code in and create pull requests:
- "github" → github/github.
- "github-ui" → github/github-ui

Here are the most common public repos where we interact with issues, but they have no code:
- "repos" → github/repos
- "security" → github/repos-security

The "private repo" is just for our notes and plans, so they don't clutter up the issues and pull requests with things
that are useful to us, but not to team members:
- "daryl" or "daryl repo" or "private repo" or "tracking repo" → github/daryl

 "Tracking issue" means the issue in the private repo which is tracking a specific public issue.

 "Related issues" means this: for any public issue, find its top-level parent issue -- the issue with no parent. That
 might be itself. Then find all issues which are descendents of any degree, of that top-level issue. The top-level
 issue plus all of descendents is the set of "related issues". Traking issues should not have parents or children,
 so if we talk about the "related issues" of a tracking issue, you would have to find these by looking at the public
 issue it is tracking.

## Issue references

If you see a reference like `security#1234` it means issue or pull request 1234 in the security repo
(`github/repos-security`). `daryl#15` is issue 15 in the daryl repo, and so forth.

## General rules

Never create issues or pull requests in public repositories without getting specific instructions or asking permission.
Creating issues in the tracking repo (github/daryl) is fine.

Do not push to public repositories unless specifically instructed to. If you are ready to push but I haven't told you
to, ask first then push.

In general, use lots of detail when updating tracking issues. This keeps us from forgetting things we already figured
out. Use less details in public issues and pull requests. Don't clutter these up with exhaustive lists of files and
what changed; the PR has that sort of thing already.

## The agents we'll be using

Here are the agents who will be involved in development:

| Agent | Agent's Name | Agent's Jobs | Backstory |
|-|-|-|-|
| Planning Agent | Ed | Planning, creating designs | Ed Glas |
| Coding Agent| Tim | Writing code, creating pull requests | Tim Kingsbury |
| Reviewer Agent| Paul | Reviewing code | Paul Killey |
| Testing Agent | Ted | Writing tests, analyzing test failures | Novartis |
|               | Charlie | Undecided | Charlie Lotridge |
|               | Taylor | Undecided | Taylor Lafrinere |

## How to track work in progress

Work always starts with an issue in a **public repository**. The issue type depends on the size and nature of the work:

- **Bug**: A single issue for fixing something that is broken.
- **Task**: A single issue for a small, self-contained piece of work.
- **Epic**: A larger piece of work broken into multiple child Tasks. Each child Task is its own issue.

For each issue we work on, there will be one tracking issue for internal notes, thoughts, and memories about that work.

The issues we create in the tracking repo do not have parent/child relationships; they are linked to one specific public
issue. The hierarchy, if any, is expressed in the public issues.

There should be a one-to-one correspondence between issues and pull requests. If one issue will require more
than one pull request, we will create a child issue for each anticipated PR; the issue describes what will happen with
that specific PR.

Sometimes we create the issue ourselves. Other times, the issue already exists in the public repository because
someone else created it and assigned it to us. When picking up an existing issue, be careful not to overwrite
the original author's description. If it's a short placeholder, we might replace it. Otherwise, add a comment
on the issue to track our own notes and progress — ask what to do if unsure.

The "private repo" or "tracking repo" is a place for storing detailed planning state, design
notes, and project timelines. The tracking repository does not contain code; it contains one private issue for each
public issue we are or will be working on.

For every public issue we work on, we create a corresponding issue in the tracking repository if it doesn't exist.
This is where we store design notes, implementation decisions, and detailed planning state that would be too verbose for the code
repository issue. The title of a tracking issue should reference the public repository issue using this format:

```
{REPO_NAME}#{ISSUE_ID}: Short description
```

For example: `github-ui#452634: Move controls on new repo page`

When it is necessary to read or modify issues or pull requests, we will use github-mcp-server for both reading
and writing. Issues should be kept up to date with the authoritative and current status of what we are trying to
accomplish, what we have done, and what we are planning to do.

### Storing memories

To store memories for working on an issue, put the memory in the tracking issue (in github/daryl) rather than
using the local `store_memory` tool. Memories stored on the local machine might not last very long.

### Branch naming

Working branches are named using this pattern:

```
darylcantrell/{issue_number}_{short_description}
```

Where `{issue_number}` is the issue number from the **public repository**, and `short_description` is a very short
summary of what the branch is for, using snake_case (all lower-case, underscores between words).

When we create a branch for an issue, put a link to that branch in the tracking issue. If we create a pull request,
we should also link to that from the tracking issue.

## General workflow

### Gathering info

When we start working on an issue, first we should read all the artifacts in GitHub:

- The issue we are working on and all related issues. This includes both the public issues and their tracking issues.
- See if there's an existing pull request for the issue. If so, a link should exist in the tracking issue. Ifa PR
  exists, read that as well.

### Planning

Work starts with an issue in the public repository — either one we create ourselves (a Bug, Task, or Epic depending
on the scope), or one that already exists because someone else created and assigned it to us. The Planning Agent
will create the code repo issue if one doesn't already exist. For large work, the Planning Agent will create an
Epic and break the work down into manageable child Tasks, each of which is its own issue in the public repository.

In either case, the Planning Agent creates a corresponding tracking issue in github/daryl, titled with a reference
to the public repository issue (e.g. `github/github#12345: Short description`).

He will work to create and refine a design for the code and UI.

Each Task describes what is to be done for that piece of work. Ideally, each Task will be associated with one
branch in the public repository and (when it's ready) one pull request.

### Coding

The Planning Agent has broken the Epic down into manageable parts and each part has a Task describing what it will
contain. Now the Coding Agent takes over. He will create a branch where changes will be committed, named following
the branch naming convention above.

The Coding Agent will iterate on writing the code for this single task, waiting to get feedback from me as the work
progresses.

It may become clear that the Task definition as written was not optimal because:
- It has too much work and could be split into smaller, easier to understand tasks
- It has too little work and could be folded into the previous or next task
- It has more than one focus, or it contains changes which have little to do with each other

### Internal review

From time to time, The Reviewer Agent will be asked to form an opinion of the code being written. This agent will
focus on finding weaknesses in the design, or ways in which the code might be improved.

### Tracking tests

Every tracking issue should keep a list of all tests which are relevant to the work for that issue.
Usually this will just be a list of files, with every test in the listed file run.
Whenever we add to this list, remember to add it to both the tracking issue we are working on, and the tracking issues
for all of the public issue's ancestors (if any). Ed will populate an initial list during planning.

When we run tests, we should run any test which is listed in the public issue we're working on, or any of its ancestors.
Note that you can't just look at the public issue's parents, since the list of tests is in the tracking issue. You have
to find the tracking issue for each ancestor.

During development, Tim will probably add new tests. We might also discover new tests which are relevant and should be
run, as development proceeds. It's also possible that when we submit a pull request and the CI builds run, some tests
in unexpected files will fail.

This list of tests should grow over time. Don't remove items from this list unless specifically instructed to. Any test file
which had failures or problems during any earlier phase of a multi-issue task is worth running for the remainder of the work effort.

Finding a failing test after pushing new code will often take 20 minutes or more. It is better to run unnecessary
tests locally before pushing, than to omit a test and potentially lose half an hour of development time.
