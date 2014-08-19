through2 = require 'through2'
{ isRTL, guessDir } = require './utils'

module.exports = (options = { fallback: 'ltr' }) ->
    processFile = (file, enc, done) ->
        if file.isPost
            { $ } = file
            { fallback } = options
            total = rtl: 0, ltr: 0

            $('code').each (i, el) ->
                $el = $(el)
                $el.attr 'dir', 'ltr'
                $el.attr 'lang', 'en'

            $('pre code').each (i, block) ->
                $block = $(block)
                $block.attr 'lang', 'en'
                $block.parent('pre').attr 'dir', 'ltr'
                $block.find('.hljs-comment').each (i, comment) ->
                    $comment = $(comment)
                    $comment.attr 'dir', 'rtl' if isRTL $comment.text()

            getTextDir = (i, el) ->
                $el = $ el
                $clone = $el.clone()
                text = $clone.remove('pre, code').text().trim() || $clone.text()
                dir = guessDir text, fallback
                $el.attr 'dir', dir if dir isnt fallback
                total[dir] += 1

            $('h1, h2, h3, h4, h5, h6, p, ul').each getTextDir
            file.dir = if total.rtl > total.ltr then 'rtl' else fallback
            $.root().attr 'dir', file.dir

            file.contents = new Buffer $.html()
        done null, file

    through2.obj processFile