
function create_letters() {
    var letters = 'abcdefghijklmnopqrstuvxywz';
	var finalHTML = '';
	for (var i = 0; i < letters.length; i++) {
        finalHTML += "<div id=\"" + letters[i] + "\" class=\"letters\"> <img src=\"/img/letters/" + letters[i] + ".png\"> </div>";
	}	
    $('#alphabet').html(finalHTML);
    $('.letters').click(use_letter);
}

function create_buckets() {
	var finalHTML = '';
	for (var i = 0; i < Game.word.length; i++) {
        finalHTML += "<img id=\"bucket-" + i +  "\" src=\"/img/letters/__.png\">";
	}	
    $('#buckets').html(finalHTML);
}

function use_letter() {
    if (Game.finished) return;
    $(this).addClass("used_letter");
    var letter = $(this).attr('id');
    if (Game.word.indexOf(letter) != -1) {
        if (Game.right_letters.indexOf(letter) == -1) {
            Game.right_letters += letter;
            update_buckets(letter);
        }
    } else {
        if (Game.wrong_letters.indexOf(letter) == -1) {
            Game.wrong_letters += letter;
            hang_more(letter);
        }
    }
}

function update_buckets(letter) {
    var finalHTML = '';
    var right_buckets = 0;
	for (var i = 0; i < Game.word.length; i++) {
        if (Game.right_letters.indexOf(Game.word[i]) != -1) {
            var b = $('#bucket-' + i);
            b.attr("src", "/img/letters/" + Game.word[i] + ".png");
            right_buckets++;
        }
    }
    if (right_buckets == Game.word.length) {
        game_finished(true);
    }
}

function hang_more(letter) {
    var finalHTML = '';
	for (var i = 0; i < Game.wrong_letters.length; i++) {
        finalHTML += "<span class=\"letters used_letter\">" + Game.wrong_letters[i] + "</span>";
    }
    $('#wrong_letters span').html(finalHTML);
    if (Game.wrong_letters.length > 5) {
        game_finished(false);
    }
	$('#game_state img').attr('src', '/img/' + Game.wrong_letters.length.toString() + 'errors.png');
}

function display_game_end(element) {
    $(element).show()
    $('#end_game').modal();
}   

function game_finished(win) {
    Game.finished = true;
    $.post('/play', {wrong_letters: Game.wrong_letters, right_letters: Game.right_letters, game_key: Game.game_key}, function(data) {
        if (win) {
            display_game_end('#win');
        } else {
            display_game_end('#lose');
        }
    });
}

$(document).ready(function () {
    create_letters();   
    create_buckets();
});