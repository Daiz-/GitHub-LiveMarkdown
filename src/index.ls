# configure marked
marked.set-options do
  gfm: true
  tables: true
  breaks: true
  highlight: (code, lang) ->
    if lang then
      hljs.highlight-auto code .value
    else code

# formatting function
format = (text) ->
  text = Linkify.all text, context
  text = Emoji text
  marked text

# settings
show-preview = local-storage.get-item \LiveMarkdownPreview
show-preview ?= \true
show-preview = if show-preview is \true then true else false

# toggle preview on / off
toggle-preview = !->
  it.prevent-default!
  !:=show-preview
  local-storage.set-item \LiveMarkdownPreview show-preview
  if show-preview
    preview-bucket.class-list.remove \preview-hidden
    text = textarea.value or 'Nothing to preview'
    preview.innerHTML = format text
  else preview-bucket.class-list.add \preview-hidden

# find the important elements
content = d.query-selector \.write-content
textarea = content.query-selector \textarea
head = d.head

# create the button link
button = d.create-element \a
  ..class-name = 'js-toggle-live-preview tooltipped leftwards'
  ..href = \#
  ..set-attribute \original-title 'Live Preview'
  ..add-event-listener \click toggle-preview

# create the button icon
icon = d.create-element \span
  ..class-name = 'octicon octicon-live-preview'

# create the style elements
css = d.create-element \style
  ..class-name = \live-preview-styling 
  ..text-content = \INLINE_CSS

css-pre = d.create-element \style
  ..class-name = \live-preview-code-styling
  ..text-content = \INLINE_PRE_CSS

head
  ..append-child css
  ..append-child css-pre

button.append-child icon
content.insert-before button, content.first-child
Tipsy button

# create preview element
preview-bucket = d.query-selector \.preview-content
  .child-nodes.1.clone-node true
preview = preview-bucket.query-selector \.comment-body

if not show-preview then preview-bucket.class-list.add \preview-hidden
content.append-child preview-bucket

update-preview = !->
  text = textarea.value or 'Nothing to preview'
  if show-preview
    preview.innerHTML = format text

# add event listeners for updating
textarea.add-event-listener \input update-preview
