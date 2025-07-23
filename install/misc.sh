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
gh extension install CallMeGreg/gh-language
gh extension install ChrisCarini/gh-copilot-review
gh extension install HaywardMorihara/gh-tidy
gh extension install github/gh-skyline
gh extension install hectcastro/gh-metrics
gh extension install kawarimidoll/gh-graph
gh extension install rsese/gh-actions-status
gh extension install seachicken/gh-poi
gh extension install vilmibm/gh-screensaver