sitedir       = _site

produser   = chigby
prodhost   = nullsurface.com
proddir    = ~/webapps/spokenrune

testuser   = $(produser)
testhost   = $(prodhost)
testdir    = ~/webapps/spokenrunetest

switches = -rtz --chmod=ugo=rwX --delete

clean:
	rm -rf $(sitedir)/*

serve: clean
	jekyll serve --watch

build: clean
	jekyll build

test: build push-test

deploy: build push-production

push-test:
	rsync $(switches) $(sitedir)/ $(testuser)@$(testhost):$(testdir)

push-production:
	@status=$$(git status --porcelain); \
        if test "x$${status}" = x; then \
            rsync $(switches) $(sitedir)/ $(produser)@$(prodhost):$(proddir) \
        else \
            echo Working directory is dirty >&2; \
        fi

.PHONY: clean
