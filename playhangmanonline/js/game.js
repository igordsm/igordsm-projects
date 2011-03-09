
function init() {
	var links = document.getElementById("alphabet");
	var wrong = document.getElementById("l").innerText;
	var buckets = document.getElementById("buckets").innerText;
	if (wrong.length >= 5) {
		document.getElementById("loose").style.display = "block";
		document.getElementById("play_new_game").style.display = "block";
	} else if (buckets.indexOf("__") == -1) {
		document.getElementById("win").style.display = "block";
		document.getElementById("play_new_game").style.display = "block";
	}
	var letters = 'abcdefghijklmnopqrstuvxywz';
	var finalHTML = '';
	for (var i = 0; i < letters.length; i++) {
		if (wrong.indexOf(letters[i]) == -1 && buckets.indexOf(letters[i])) {
			finalHTML += "<a href=\"" + game_link + letters[i] + "\">";
		}
		finalHTML += letters[i];
		if (wrong.indexOf(letters[i]) == -1 && buckets.indexOf(letters[i])) {
			finalHTML += "</a>";
		}
	}	
	links.innerHTML = finalHTML;
}