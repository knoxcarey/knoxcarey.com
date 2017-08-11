# This makefile assumes GNU make

# External programs to user
mmd = /usr/local/bin/multimarkdown
awk = /usr/local/bin/gawk

# Current theme
theme = ../themes/current

# Number of posts to be included on each index page
posts_per_index_page = 5

# Convert multimarkdown files to bare HTML snippets
%.body.html: %.md
	$(mmd) -s $< > $@

# Build a standalone post page from a snippet
%.post.html: %.md $(theme)/post_header.html %.body.html $(theme)/post_footer.html
	$(awk) -f meta.awk $^ > $@

