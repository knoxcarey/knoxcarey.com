# Notes

This is my personal blog. The setup is a work in progress.
My idea here is to have the entire thing checked in to github, then
have a set of scripts/programs on the hosting machine to build the
HTML pages. Presumably the host would check for commits periodically,
or listen on a particular port for a notice that changes were
made. This would trigger an update and rebuild.

## Structure

Right now, the structure is:

* code/
  Programs and scripts to generate the blog from sources

* media/
  Directory for images, video, etc. included on various pages

* posts/
  Directory to hold posts, in various stages of their lifecycle

* static/
  The actual "built" blog. Generated by scripts/programs

* themes/
  Directory for CSS and so forth for styling the blog. One
  subdirectory for each theme.

* themes/current/ a symbolic link to the current theme being used

## Todo

1. Dynamic keywords, e.g. post date
2. Start building index pages