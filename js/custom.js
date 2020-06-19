jQuery(function( $ ){
    $('#topnav ul li a').bind('click', function(e) {
        e.preventDefault();
        target = this.hash;
        $.scrollTo(target, 1000, {offset:-80});
    });
    $('#training a.location').bind('click', function(e) {
        e.preventDefault();
        target = this.hash;
        $.scrollTo(target, 1000, {offset:-80});
    });
});
