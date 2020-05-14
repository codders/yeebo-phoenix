THEME_VERSION=1.0.0

html: yeebo-opensocial-theme-v$(THEME_VERSION).tar.gz
	mkdir html
	ddev composer install
	# Fix shariff library distribution issue
	cp html/libraries/shariff/dist/* html/libraries/shariff
	# Fix for drupal issue 3102797 (https://www.drupal.org/project/social/issues/3102797)
	patch -p1 < patches/01_open-social-search-bugfix-3102797.patch
	# Fix for social mentions null dereference
	patch -p1 < patches/02_open-social-mentions-bug.patch
	# Install modules
	cp -a modules/* html/modules
	# Install theme
	mkdir -p html/themes/custom && tar xpvf yeebo-opensocial-theme-v$(THEME_VERSION).tar.gz -C html/themes/custom --transform="s/^yeebo-opensocial-theme-$(THEME_VERSION)/yeebo_v1/"

yeebo-opensocial-theme-v$(THEME_VERSION).tar.gz:
	curl -L https://github.com/codders/yeebo-opensocial-theme/archive/v1.0.0.tar.gz > $@

clean:
	rm -rf html yeebo-opensocial-theme*.tar.gz

.PHONY: clean
