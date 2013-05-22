Linkify =
  sha1: (text, context, ret = '') ->
    start = end = 0
    regex = /([A-Za-z0-9-]+)?\/?([A-Za-z0-9_-]+)?@?([a-f0-9]{40})/g
    while res = regex.exec text
      [matched, user, repo, hash] = res
      start = end
      end = res.index - start + matched.length
      current = text.substr start, end
      short = hash.substr 0 8
      ctx-user = context.split '/' .0
      ret += current.replace matched, if user == ctx-user and not repo
        "[#user@`#short`](https://github.com/#context/commit/#hash)"
      else if user and repo
        "[#user/#repo@`#short`](https://github.com/#user/#repo/commit/#hash)"
      else if user == repo == void
        "[`#short`](https://github.com/#context/commit/#hash)"
      else
        matched
    ret

  issue: (text, context, ret = '') ->
    start = end = 0
    regex = /([A-Za-z0-9-]+)?\/?([A-Za-z0-9_-]+)?#([0-9]+)/g
    while res = regex.exec = text
      [matched, user, repo, num] = text.match regex
      start = end
      end = res.index - start + matched.length
      current = text.substr start, end
      ctx-user = context.split '/' .0
      ret += current.replace matched, if user == ctx-user and not repo
        "[#user##num](https://github.com/#context/issues/#num"
      else if user and repo
        "[#user/#repo##num](https://github.com/#user/#repo/issues/#num"
      else if user == repo == void
        "[#num](https://github.com/#context/issues/#num)"
      else
        matched
    ret

  mention: (text) ->
    name = text.match /@([A-Za-z0-9-]+)/ .1
    if name == \mention
      "<a class='user-mention' href='https://github.com/blog/821'>@#name</a>"
    else
      "<a class='user-mention' href='https://github.com/#name'>@#name</a>"