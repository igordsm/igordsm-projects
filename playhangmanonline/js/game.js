
function init() {
	var links = document.getElementById("alphabet");
	var wrong = document.getElementById("l").innerHTML || "";
	var buckets = document.getElementById("buckets").innerHTML || "";
	if (wrong.length > 5) {
		document.getElementById("loose").style.display = "block";
		document.getElementById("play_new_game").style.display = "block";
	} else if (buckets.indexOf("__") == -1) {
		document.getElementById("win").style.display = "block";
		document.getElementById("play_new_game").style.display = "block";
	}
	var letters = 'abcdefghijklmnopqrstuvxywz';
	var finalHTML = '';
	for (var i = 0; i < letters.length; i++) {
		if (wrong.indexOf(letters[i]) == -1 && buckets.indexOf(letters[i]) == -1) {
			finalHTML += "<a href=\"" + game_link + letters[i] + "\">";
		} else {
            finalHTML += "<span>";
        }
		finalHTML += letters[i];
		if (wrong.indexOf(letters[i]) == -1 && buckets.indexOf(letters[i]) == -1) {
			finalHTML += "</a>";
		} else {
            finalHTML += "</span>";
        }
	}	
	links.innerHTML = finalHTML;
}