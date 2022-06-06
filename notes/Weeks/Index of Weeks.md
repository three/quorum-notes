# Index of Weeks
*removed*
## Script
```zsh
find . | egrep -o 'Week of \d{4}-\d{2}-\d{2}' | awk '{ print "- [[" $0 "]]" }'
```