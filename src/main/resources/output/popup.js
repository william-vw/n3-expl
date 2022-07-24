function loaded() {
	const links = document.getElementsByClassName('popuplink');
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

	//	info.classList.add('show');

	/* // hide other info elements
	const links = document.getElementsByClassName('popuplink');
	for (var link2 of links) {
		if (link2 !== link) {
			const info2 = link2.nextSibling;
//			info.classList.remove('show');
			info2.style.display = "none";
		}
	} */
}