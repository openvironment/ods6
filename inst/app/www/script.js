function clickFunction(id, x) {
  console.log(id + " e " + x);
  Shiny.onInputChange(id, x);
}

function mudarAba(id, id_new) {
  var element = document.getElementById(id);
  var element_new = document.getElementById(id_new);
  element.classList.remove("active");
  element_new.classList.add("active");
}