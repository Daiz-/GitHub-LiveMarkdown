# configure marked
marked.set-options do
  gfm: true
  tables: true
  breaks: true
  highlight: ->
    hljs.highlight-auto it .value

# shortcuts
d = document

# settings
show-preview = local-storage.get-item \LiveMarkdownPreview
if show-preview == null then show-preview = true
show-preview = switch show-preview
| "true"  => true
| "false" => false

# toggle preview on / off
toggle-preview = !->
  it.prevent-default!
  show-preview := !show-preview
  local-storage.set-item \LiveMarkdownPreview, show-preview
  if show-preview then
    preview-bucket.class-list.remove \preview-hidden
    text = textarea.value || 'Nothing to preview'
    preview.innerHTML = marked text
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
  ..add-event-listener \click, toggle-preview, false

# create the button icon
icon = d.create-element \span
  ..class-name = 'octicon octicon-live-preview'

# create the style elements
css = d.create-element \style
  ..class-name = \live-preview-styling 
  ..text-content = \INLINE-CSS

css-pre = d.create-element \style
  ..class-name = \live-preview-code-styling
  ..text-content = \INLINE-PRE-CSS

# create the script element
js = d.create-element \script
  ..src = \INLINE-JS

# append initial elements to appropriate places
head
  ..append-child css
  ..append-child css-pre

button.append-child icon
content.insert-before button, content.first-child

d.body.append-child js

# create preview element
preview-bucket = d.query-selector \.preview-content
  .child-nodes.1.clone-node true
preview = preview-bucket.query-selector \.comment-body

if not show-preview then preview-bucket.class-list.add \preview-hidden
content.append-child preview-bucket

update-preview = !->
  text = it.target.value || 'Nothing to preview'
  if show-preview then
    preview.innerHTML = marked text

# add event listener for keyup
textarea.add-event-listener 'keyup', update-preview, false