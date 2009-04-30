window.onload = function(){
	var collections = document.getElementById('collections');
	var collections_link = document.getElementById('collections_link');
	collections_link.onmouseenter = function(){
		collections.style.display = '';
		collections.onmouseleave = function(){
			collections.style.display = 'none';
			collections.onmouseleave = null;
		};
	};
};