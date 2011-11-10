$(document).ready(function () {
    /*$(window).hashchange(function(e) {
        $(".topNavAct").removeClass("topNavAct");
        var destination = location.hash.substring(1);
        if (destination == "") {
            destination = "home.html";
        }
        $("#ref-" + destination).addClass("topNavAct");
        $("#content").load("content/" + destination);
    });
    
    $(window).hashchange();*/
});

function template_me(template_path) {
    $.get(template_path, {}, function(data) {
        var replaces = {};
        $("div[id*='replace']").each(function (index, element) {
            var t = $(element);
            replaces[t.attr('id').replace('replace_', '')] = t.html();
            $(element).remove();
        });
        $("html").html(data);  
        for (var k in replaces) {
            $('#template_' + k).html(replaces[k]);
        }
    });
}