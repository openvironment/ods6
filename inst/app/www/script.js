function clickFunction(id, x) {
  console.log(id + " e " + x);
  Shiny.onInputChange(id, x);
}