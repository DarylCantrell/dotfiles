---
name: ship-post
description: Write a post announcing a new feature being enabled. Use when a user wants to write a ship post for an epic, a set of tasks, or some ad-hoc change.
---

## What's a ship post?

A post announcing that we are shipping a new feature.

Someimtes when we ship new features, we write a short post announcing them and describing what they do and why.

Usually, we ship them first to internal staff only. This way if there are bugs, we haven't inconvenienced the whole world.

In this context, "shipping" doesn't mean merging a pull request or closing an issue. It means making new functionality
available. Usually, a feature which is important enough to warrant an announcement will be controlled by one or more
feature flags. In that case, "shipping" means turning those feature flags on, either just for our internal staff repositories
or for the whole world.

## How to write a ship post

First you'll need to know which epic or which task(s) are being shipped. If that hasn't been provided, you should ask.
You'll also need to know if we're just announcing "staff ship" or if we're shipping it to the whole world.

The ship post announces that a new feature is being enabled, and describes:

- An overall summary of the changes, and why the changes are being made (how will this improve the product for our customers?)
- A description of what the user will see and how our product's behavior will change
- If there are visible changes in the user interface, there would generally be one or more screenshots of the new UI

Unless specifically instructed to, don't include details which are purely about implementation. Things like "here is
how we implemented this feature" or "here are the feature flags involved and what they do" are not relevant to this
wide audience. It's also not useful to the reader if we talk about unit tests, or other "programming internals".
Things which might be important to someone reviewing a pull request are not important to someone reading a ship
announcement.

Instead focus on what changes in appearance or behavior the user will see, any new capabilities which are being added,
and why the changes are being made.

These posts should be brief, and focus on what changes the user will see and why they are being made.
