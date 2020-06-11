Title:		Metablog
Tags:		blog
Author:		knox

# Weekend Project

I spent a few hours last weekend trying to see if I could create a
very simple static blog generator. My experiment was successful -- it
was used to generate this page. My primary design goal was to avoid
using any kind of database that I would have to maintain. I just
wanted to use plain files, preferably stored in a repository
somewhere.

## AWK Script

Here is an example of an awk script

```
# Trim whitespace from ends of string
function trim(s) { gsub(/(^\s+|\s+$)/, "", s); return s }

# Initialize variables
BEGIN {
  FS = ":[ \t]+"                              # Metadata split pattern
    IGNORECASE = 1                              # Match case-insensitive
      kv["{{updated}}"] = strftime("%e %B %Y")    # Update timestamp
        kv["{{date}}"] = date                       # Date passed in on cmd line
	  kv["{{permalink}}"] = permalink             # Permalink passed in
	  }

# Extract metadata from first two files; stop at first whitespace-only line
ARGIND <= 2 && /^\w+\s*:\s+.*$/ { kv["{{" trim($1) "}}"] = trim($2) }
ARGIND <= 2 && /^\s*$/          { nextfile }

# Make substitutions in subsequent files
ARGIND > 2 && /{{/ { for (k in kv) gsub(k, kv[k]); gsub(/{{.*}}/, "") }
ARGIND > 2 { print }
```
