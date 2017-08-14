# Note: This makefile assumes GNU make (gmake)

# External programs to user
mmd = /usr/local/bin/multimarkdown
awk = /usr/local/bin/gawk

# Current theme
theme = ../themes/current

# Blog configuration
config = ../config/blog

# Number of posts to be included on each index page
posts_per_index_page = 5

# Convert multimarkdown files to bare HTML snippets
%.body.html: %.md
	$(mmd) -s --nosmart $< > $@

# Build the post HTML by applying theme, interpolating variables, etc.
%.post.html: $(config) %.md $(theme)/post_header.html %.body.html $(theme)/post_footer.html
	$(awk) -f meta.awk $^ > $@

# Create a standalone page = header + post + footer
%.ppheader.html: $(config) %.md $(theme)/postpage_header.html
	$(awk) -f meta.awk $^ > $@
%.ppfooter.html: $(config) %.md $(theme)/postpage_footer.html
	$(awk) -f meta.awk $^ > $@
%.html: %.ppheader.html %.post.html %.ppfooter.html
	cat $^ > $@



