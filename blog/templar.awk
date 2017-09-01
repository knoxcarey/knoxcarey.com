############################################################################
# This file reads metadata key/value pairs from the top of a blog post
# and substitutes those values into template documents. It's basically a
# lightweight template engine.
#
# The first two files given as an argument should contain colon-delimited
# key/value pairs on successive lines, starting on the first line --
# the files cannot contain any whitespace lines at the top. An example
# of the file format:
#
# Title:  My Awesome Post
# Tags:   foo, bar, baz
# Author: knox
#
# ... text of blog post ...
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
#   gawk -f templar.awk config post.md template.html
#
# Where templar.awk is this file, config is a blog-wide set of key-value
# pairs, post.md is a blog post with key/value metadata at the top,
# and template.html is the template file with metadata tags to be
# filled in. 
#
# Notes:
#   1. This program assumes the use of GNU AWK (gawk)
#   2. The key/value separator, a colon, must be followed by
#      at least some whitespace (spaces/tabs)
#   3. Case does not matter, either in the colon-separated key/value
#      pairs, or in the double-curly-braced keywords in templates
#   4. This templating engine does not attach any semantic value to
#      keyword tags -- that's left to downstream tools
#   5. The templating engine eliminates unknown tags from the template
#      files; i.e. keywords for which no values have been defined
############################################################################


# Trim whitespace from ends of string
function trim(s) { gsub(/(^\s+|\s+$)/, "", s); return s }

# Initialize variables
BEGIN {
  FS = ":[ \t]+"                              # Metadata split pattern
  IGNORECASE = 1                              # Match case-insensitive
  kv["{{updated}}"] = strftime("%e %B %Y")    # Update timestamp
  kv["{{date}}"] = date                       # Date passed in on cmd line
  kv["{{permalink}}"] = permalink             # Permalink
  kv["{{seq}}"] = seq                         # Sequence number (for indices)
  kv["{{nseq}}"] = nseq                       # Total index count
}

# Extract metadata from first two files; stop at first whitespace-only line
ARGIND <= 2 && /^\w+\s*:\s+.*$/ { kv["{{" trim($1) "}}"] = trim($2) }
ARGIND <= 2 && /^\s*$/          { nextfile }

# Make substitutions in subsequent files
ARGIND > 2 && /{{/ { for (k in kv) gsub(k, kv[k]); gsub(/{{.*}}/, "") }
ARGIND > 2 { print }
