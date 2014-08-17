sanitizeText = (text) -> text.replace /@\w+/, ''

countMatches = (text, match) ->
    matches = text.match new RegExp match, 'g'
    if matches then matches.length else 0

isRTL = (text) ->
    text = sanitizeText text
    count_rtl = countMatches text, '[\\u060C-\\u06FE\\uFB50-\\uFEFC]'
    count_rtl * 100 / text.length > 20

isLTR = (text) ->
    text = sanitizeText text
    count_ltr = countMatches text, '^[\\u060C-\\u06FE\\uFB50-\\uFEFC]'
    count_ltr * 100 / text.length > 60

guessDir = (text, fallback='ltr') ->
    return 'rtl' if isRTL text
    return 'ltr' if isLTR text
    return fallback

module.exports = { isRTL, isLTR, guessDir }