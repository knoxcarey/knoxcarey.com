############################################################################
# This file reads metadata key/value pairs from the top of a blog post
# and substitutes those values into template documents. It's basically a
# lightweight template engine.
#
# The first file given as an argument should contain colon-delimited
# key/value pairs on successive lines, starting on the first line --
# the file cannot contain any whitespace lines at the top. An example
# of the file format:
#
# Title: My Awesome Post
# Tags: foo, bar, baz
# Author: knox
#
# ... text of post ...
#
# In the template files, use double curly braces to indicate where a
# value should be substituted. So, for example, using the metadata
# above, we can process the following template file:
#
# The title of the post is "{{TITLE}}" and the author is {{AUTHOR}}
#
# This would yield the string:
#
# The title of the post is "My Awesome Post" and the author is knox
#
# Invoke the command line this:
#   gawk -f meta.awk post.md template.html
#
# Notes:
#   1. This program assumes the use of GNU AWK (gawk)
#   2. Case does not matter, either in the colon-separated key/value
#      pairs, or in the double-curly-braced keywords in templates
############################################################################


# Trim whitespace from ends of string
function trim(s) { gsub(/(^\s+|\s+$)/, "", s); return s }


# Separate lines on colons; ignore case in matches
BEGIN {
  FS=":"
  IGNORECASE=1
}

# Extract key/value metadata from first file
NR == FNR && /^\w+\s*:\s*.+$/ {
  meta["{{" trim($1) "}}"] = trim($2)
}

# Stop processing metadata on whitespace-only line
NR == FNR && /^\s*$/ {
  nextfile
}

# Make substitutions in subsequent files
NR != FNR && /{{\w+}}/ {
  for (key in meta) gsub(key, meta[key])
  print
}

