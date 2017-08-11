# This makefile assumes GNU make

# Multimarkdown tool
mmd = /usr/local/bin/multimarkdown

# Current theme
theme = ../themes/current

# Number of posts to be included on each index page
posts_per_index_page = 5

# Convert multimarkdown files to bare HTML snippets
%.body.html: %.md
	$(mmd) -s $< > $@

# Extract metadata from multimarkdown post
# %.meta: %.md
# 	@tags = $(shell $(mmd) -m $<)
# 	echo $(tags)

# Build a standalone post page from a snippet
%.post.html: $(theme)/post_header.html %.body.html $(theme)/post_footer.html
	cat $^ > $@

