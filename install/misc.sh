#!/usr/bin/env bash
####
# MISCELLANEOUS PROGRAMS
####


#############
# `clockwise`
# -----------
# Description: Clockwise is a meeting cost calculator
#              designed to encourage more efficient meetings.
# GitHub: https://github.com/syncfast/clockwise
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"
go install github.com/syncfast/clockwise@master


#####################
# `gh` CLI extensions
# -------------------
gh extension install rsese/gh-actions-status
gh extension install kawarimidoll/gh-graph
gh extension install gabe565/gh-profile
