# Note: This makefile assumes GNU make (gmake)

# External programs to use
mmd = /usr/local/bin/multimarkdown
awk = /usr/local/bin/gawk

# Publication directory
pub = publish/axiomatic

# Posts to publish
posts = $(wildcard posts/published/*.md)
pages = $(patsubst posts/published/%.md, %.html, $(posts))

# Make staging directory for storing built products
staging:
	mkdir -p staging

# Make publication directory
pubdir:
	mkdir -p $(pub)

# Convert multimarkdown files to bare HTML snippets
%.body.html: posts/%.md
	$(mmd) -s --nosmart $< > $@

# Build the post HTML by applying theme, interpolating variables, etc.
.PRECIOUS: staging/posts/%.post.html
staging/posts/%.post.html: posts/published/%.md config/blog themes/current/post_header.html \
			   %.body.html themes/current/post_footer.html | staging
	$(eval pubdate = $(shell stat -t "%e %B %Y" -f "%Sc" $<))
	$(eval perma = $(patsubst %.post.html, %.html, $(@F)))
	$(awk) -f code/meta.awk -v 'date=$(pubdate)' -v 'permalink=$(perma)' $^ > $@

# Create a standalone page
%.header.html: config/blog posts/%.md themes/current/postpage_header.html
	$(awk) -f code/meta.awk $^ > $@
%.footer.html: config/blog posts/%.md themes/current/postpage_footer.html
	$(awk) -f code/meta.awk $^ > $@
.PRECIOUS: staging/pages/%.html
staging/pages/%.html: %.header.html staging/posts/%.post.html %.footer.html | staging
	cat $^ > $@

# Rule to publish staged files
%.html: staging/pages/%.html | pubdir
	ln -f -s ../../$< $(pub)/$@

# Publish blog
publish: $(pages) | pubdir
	ln -f -s ../../themes/current $(pub)/theme
	ln -f -s ../../media $(pub)/media

# Clean up all the things
.PHONY: clean
clean:
	rm -f staging/*/*
	rm -rf publish


# ######## NOTES #########
# * How to do index files now, with linking?
# * RSS feed

