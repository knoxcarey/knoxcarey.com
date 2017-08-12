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
# Title: My Awesome Post
# Tags: foo, bar, baz
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
#   gawk -f meta.awk config post.md template.html
#
# Where meta.awk is this file, config is a blog-wide set of key-value
# pairs, post.md is a blog post with key/value metadata at the top,
# and template.html is the template file with metadata tags to be
# filled in. 
#
# Notes:
#   1. This program assumes the use of GNU AWK (gawk)
#   2. Case does not matter, either in the colon-separated key/value
#      pairs, or in the double-curly-braced keywords in templates
#   3. This templating engine does not attach any semantic value to
#      keyword tags -- that's left to downstream tools.
#   4. You can adjust the character that separates key/value pairs in
#      the BEGIN clause, below. You can also change the strings that
#      should be recognized as the starts and ends of a keyword in the
#      template files. The default separator is ":", and the keywords
#      in templates are surrounded by ""{{" and "}}" by default.
#   5. Set the variable DELETE_UNKNOWN to 1 to have the engine
#      eliminate unknown tags from the template files; i.e. keywords
#      for which no values have been defined.
############################################################################


# Trim whitespace from ends of string
function trim(s) { gsub(/(^\s+|\s+$)/, "", s); return s }


# Set up global variables
BEGIN {
  # User-defined constants
  SEPARATOR = ":"               # Key/value separator in metadata file               
  OPEN = "{{"                   # Characters that open a substitution tag
  CLOSE = "}}"                  # Characters that close a substitution tag
  TAG = OPEN ".+" CLOSE         # Regex matching any tag
  DELETE_UNKNOWN = 1            # Whether or not to delete unknown tags
  
  # Special AWK variables
  FS = SEPARATOR                # Split metadata lines on user-defined char
  IGNORECASE = 1                # Make tag matching case-insensitive

  # Automatic metadata
  meta[OPEN "updated" CLOSE] = strftime("%e %B %Y")
}

# Extract key/value metadata from first two files
ARGIND <= 2 && /^\w+\s*:\s*.+$/ {
  meta[OPEN trim($1) CLOSE] = trim($2)
}

# Stop processing metadata on whitespace-only lines
ARGIND <= 2 && /^\s*$/ {
  nextfile
}

# Make substitutions in subsequent files
ARGIND > 2 {
  for (key in meta) gsub(key, meta[key])
  if (DELETE_UNKNOWN) gsub(TAG, "")
  print
}
