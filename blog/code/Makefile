# Note: This makefile assumes GNU make (gmake)

# External programs to user
mmd = /usr/local/bin/multimarkdown
awk = /usr/local/bin/gawk

# Current theme
theme = ../themes/current

# Blog configuration
config = ../config/blog

# Directory with posts
posts = ../posts

# Convert multimarkdown files to bare HTML snippets
%.body.html: $(posts)/%.md
	$(mmd) -s --nosmart $< > $@

# Build the post HTML by applying theme, interpolating variables, etc.
%.post.html: $(config) $(posts)/%.md $(theme)/post_header.html %.body.html $(theme)/post_footer.html
	$(awk) -f meta.awk $^ > $@

# Create a standalone page = header + post + footer
%.ppheader.html: $(config) $(posts)/%.md $(theme)/postpage_header.html
	$(awk) -f meta.awk $^ > $@
%.ppfooter.html: $(config) $(posts)/%.md $(theme)/postpage_footer.html
	$(awk) -f meta.awk $^ > $@
%.html: %.ppheader.html %.post.html %.ppfooter.html
	cat $^ > $@



