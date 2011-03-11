
wrong_letters = [];
right_letters = [];

function create_letters() {
    var letters = 'abcdefghijklmnopqrstuvxywz';
	var finalHTML = '';
	for (var i = 0; i < letters.length; i++) {
        finalHTML += "<span id=\"" + letters[i] +  "\" class=\"letters\">" + letters[i] + "</span>";
	}	
    $('#alphabet').html(finalHTML);
    $('.letters').click(use_letter);
}

function use_letter() {
    $(this).addClass("used_letter");
    var letter = $(this).html();
    if (word.indexOf(letter) != -1) {
        right_letters.push(letter);
        update_buckets(letter);
    } else {
        wrong_letters.push(letter);
        hang_more(letter);
    }
}

function update_buckets(letter) {

}

function hang_more(letter) {

}

$(document).ready(function () {
    create_letters();   
    
});