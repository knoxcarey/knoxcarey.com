# Note: This makefile assumes GNU make (gmake)

# External programs to use
mmd = /usr/local/bin/multimarkdown
awk = /usr/local/bin/gawk

# Publication directory
pub = publish/axiomatic

# Posts to publish
posts = $(wildcard posts/publish/*.md)
pages = $(patsubst posts/publish/%.md, %.html, $(posts))

# Convert multimarkdown files to bare HTML snippets
%.body.html: posts/%.md
	$(mmd) -s --nosmart $< > $@

# Modification date timestamp
%.ts: posts/%.md
	$(eval pubdir = $(shell stat -t "$(pub)/%Y/%m/%d" -f "%Sm" $<))
	mkdir -p $(pubdir)
	echo $(pubdir) > $@

# Make staging directory for storing built products
staging:
	mkdir -p staging

# Build the post HTML by applying theme, interpolating variables, etc.
.PRECIOUS: staging/posts/%.post.html
staging/posts/%.post.html: config/blog posts/%.md themes/current/post_header.html \
			   %.body.html themes/current/post_footer.html | staging
	$(awk) -f code/meta.awk $^ > $@

# Create a standalone page = header + post + footer
%.ppheader.html: config/blog posts/%.md themes/current/postpage_header.html
	$(awk) -f code/meta.awk $^ > $@
%.ppfooter.html: config/blog posts/%.md themes/current/postpage_footer.html
	$(awk) -f code/meta.awk $^ > $@
.PRECIOUS: staging/pages/%.html
staging/pages/%.html: %.ppheader.html staging/posts/%.post.html %.ppfooter.html
	cat $^ > $@

# Rule to publish staged files
%.html: staging/pages/%.html publish | %.ts
	ln -s ../../../../../$< $(shell cat $|)/$@

# Publish blog
publish: $(pages)
	mkdir -p $(pub)
	ln -s ../../themes/current $(pub)/theme
	ln -s ../../media $(pub)/media

# Clean up all the things
.PHONY: clean
clean:
	rm -f staging/*/*
	rm -rf publish


# ######## NOTES #########
# * How to do index files now, with linking?
# * RSS feed
# * Automatic date? 

