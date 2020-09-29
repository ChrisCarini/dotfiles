# Notes

## OSX Plist
- https://medium.com/@marksiu/what-is-plistbuddy-76cb4f0c262d

## Resources
- [Text processing in the shell](https://blog.balthazar-rouberol.com/text-processing-in-the-shell)
- [jq tutorial](https://mosermichael.github.io/jq-illustrated/dir/content.html)


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

#### Get MySQL DB Size
```
SELECT table_schema "DB Name",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB"
FROM information_schema.tables
GROUP BY table_schema;
```

#### Color stderr output red
https://serverfault.com/questions/59262/bash-print-stderr-in-red-color
```bash
command 2> >(while read line; do echo -e "$(tput setaf 1)$line$(tput sgr0)" >&2; done)
```
Example:
```shell script
$ cat std_streams.sh 
echo "stdout"
echo "stderr" >&2

$ ./std_streams.sh 2> >(while read line; do echo -e "$(tput setaf 1)$line$(tput sgr0)" >&2; done)
```

#### Write `stdout` and `stderr` output to different files
```
command > >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)
``` 
(**Source:** https://stackoverflow.com/a/692407)


#### Quickly test if you can connect to a particular host/port combo
```shell script
hostname ; date ; nc -v -i 1 -w 3 doesnotexist.chriscarini.com 8443 ; date"
```