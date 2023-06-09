document.addEventListener("DOMContentLoaded", function () {
  var textElement = document.querySelector(".title-bar");

  textElement.addEventListener("click", function () {
    textElement.classList.add("animated");
  });
});
