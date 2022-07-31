function loaded() {
	const links = document.getElementsByClassName('showHideRule');
	for (var link of links)
		link.addEventListener('click', clicked);
}

function clicked(e) {
	const link = e.target;
	const info = link.nextSibling;

	// show current info element
	if (info.style.display != "block") {
		info.style.display = "block";
		link.innerHTML = "(hide rule)"
	} else {
		info.style.display = "none";
		link.innerHTML = "(show rule)"
	}
}