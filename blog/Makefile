# Note: This makefile assumes GNU make (gmake)

# External programs to use
mmd = /usr/local/bin/multimarkdown
awk = /usr/local/bin/gawk

# Current theme
theme = themes/current

# Blog configuration file
config = config/blog

# Directory with markdown posts
posts = posts

# Directory with published posts
pub = published

# Directory with scripts, etc.
code = code

# Convert multimarkdown files to bare HTML snippets
%.body.html: $(posts)/%.md
	$(mmd) -s --nosmart $< > $@

# Modification date timestamp
%.ts: $(posts)/%.md
	$(eval pubdir = $(shell stat -t "$(pub)/%Y/%m/%d" -f "%Sm" $<))
	mkdir -p $(pubdir)
	echo $(pubdir) > $@

# Build the post HTML by applying theme, interpolating variables, etc.
%.post.html: $(config) $(posts)/%.md $(theme)/post_header.html %.body.html $(theme)/post_footer.html
	$(awk) -f $(code)/meta.awk $^ > $@

# Create a standalone page = header + post + footer
%.ppheader.html: $(config) $(posts)/%.md $(theme)/postpage_header.html
	$(awk) -f $(code)/meta.awk $^ > $@
%.ppfooter.html: $(config) $(posts)/%.md $(theme)/postpage_footer.html
	$(awk) -f $(code)/meta.awk $^ > $@
%.html: %.ppheader.html %.post.html %.ppfooter.html | %.ts
	cat $^ > $(shell cat $|)/$@

