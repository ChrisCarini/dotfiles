# Notes

## Tricks

#### Diff `JSON` Blobs
Want to diff two `JSON` blobs?
```bash
jq --argfile before before.json --argfile after after.json -n '($before | (.. | arrays) |= sort) as $before | ($after | (.. | arrays) |= sort) as $after | $before == $after'
```
Want to diff two *sub-sections* of `JSON` blobs?
```bash
FILE = spec.json
jq --argfile before <(git show master:$FILE | jq .build.commands) --argfile after <(cat $FILE | jq .build.commands) -n '($before | (.. | arrays) |= sort) as $before | ($after | (.. | arrays) |= sort) as $after | $before == $after'
```
(*ref:* https://stackoverflow.com/questions/31930041/using-jq-or-alternative-command-line-tools-to-compare-json-files)

#### Get `git` file contents of specific branch
```bash
git show <branch_name>:$FILE
```