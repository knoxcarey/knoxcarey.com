# Note: This makefile assumes GNU make (gmake)

# External programs to use
mmd = /usr/local/bin/multimarkdown
awk = /usr/local/bin/gawk
parallel = /usr/local/bin/parallel

# Publication directory
pub = publish/axiomatic

# Reverse chronological list of links to published posts
published = $(shell find posts/published/*.ts | sort -r)

# Posts to publish, in reverse chronological order
posts = $(foreach p, $(published), $(addprefix posts/published/, $(shell readlink $(p))))

# Pages to generate from posts
pages = $(patsubst posts/published/%.md, %.html, $(posts))

# List of staged posts, ready for assembly
staged = $(patsubst posts/published/%.md, staging/posts/%.post.html, $(posts))

# Number of posts per index page
ppi = 5

all:
	echo $(posts)


# Make staging directory for storing built products
staging:
	mkdir -p staging/pages/
	mkdir -p staging/posts/
	mkdir -p staging/indices

# Make publication directory
pubdir:
	mkdir -p $(pub)
	ln -nfs ../../themes/current $(pub)/theme
	ln -nfs ../../media $(pub)/media

# Convert multimarkdown files to bare HTML snippets
%.body.html: posts/published/%.md
	$(mmd) -s --nosmart $< > $@

# Build the post HTML by applying theme, interpolating variables, etc.
.PRECIOUS: staging/posts/%.post.html
staging/posts/%.post.html: posts/published/%.md config themes/current/post_header.html \
			   %.body.html themes/current/post_footer.html | staging
	$(eval pubdate = $(shell stat -t "%e %B %Y" -f "%Sc" $<))
	$(eval perma = $(patsubst %.post.html, %.html, $(@F)))
	$(awk) -f templar.awk -v 'date=$(pubdate)' -v 'permalink=$(perma)' $^ > $@

# Create a standalone page
%.ph.html: config posts/published/%.md themes/current/postpage_header.html
	$(awk) -f templar.awk $^ > $@
%.pf.html: config posts/published/%.md themes/current/postpage_footer.html
	$(awk) -f templar.awk $^ > $@
.PRECIOUS: staging/pages/%.html
staging/pages/%.html: %.ph.html staging/posts/%.post.html %.pf.html | staging
	cat $^ > $@

# Create index pages
.INTERMEDIATE: ih.html
ih.html: config themes/current/index_header.html
	$(awk) -f templar.awk config $^ > $@
.INTERMEDIATE: if.html	
if.html: config themes/current/index_footer.html
	$(awk) -f templar.awk config $^ > $@
staging/indices: ih.html if.html $(staged) | staging
	$(parallel) --verbose --plus -n $(ppi)  $(awk) -f templar.awk -v "seq={#}" -v "nseq={##}" config config ih.html {} if.html '>' staging/indices/index{#}.html ::: $(staged)

# Rule to publish staged files
%.html: staging/pages/%.html | pubdir
	ln -fs ../../$< $(pub)/$@

# Publish blog
publish: $(pages) staging/indices | pubdir
	$(eval index = $(wildcard staging/indices/index*.html))
	$(foreach idx, $(index), ln -fs ../../$(idx) $(pub)/$(idx:staging/indices/%.html=%.html))
	ln -fs ./index1.html $(pub)/index.html

# Clean up all the things
.PHONY: clean
clean:
	rm -f staging/*/*
	rm -rf publish


# ######## NOTES #########
# * How to link index files?
# * RSS feed

