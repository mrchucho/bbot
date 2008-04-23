if (preview_button = $('preview_button')) {
    preview_button.observe('click',function(event) {
        $('comment_preview_author').innerHTML = $F('comment_author');
        $('comment_preview_body').innerHTML = (superTextile($F('comment_body_raw')));
        $('preview').show();
    })
}
