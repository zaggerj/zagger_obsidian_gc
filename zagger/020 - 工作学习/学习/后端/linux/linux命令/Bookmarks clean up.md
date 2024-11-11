---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# Bookmarks clean up

　　Bookmarks clean up

　　document.querySelectorAll('body .duplicate.card .card-body ul li:first-child input ').forEach(item =\> {

　　item.checked = true

　　item.dispatchEvent(new Event('change'))

　　})
