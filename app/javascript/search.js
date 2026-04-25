document.addEventListener("turbo:load", function () {
  console.log("search.js loaded");

  const form = document.getElementById("search-form");
  const input = document.getElementById("search-keyword");
  const error = document.getElementById("search-error");
  const errorBox = document.getElementById("search-error-box");

  console.log(form, input, error, errorBox);

  if (!form || !input || !error || !errorBox) return;

  if (form.dataset.searchBound === "true") return;
  form.dataset.searchBound = "true";

  form.addEventListener("submit", function (e) {
    console.log("submit detected", input.value);

    if (input.value.trim() === "") {
      e.preventDefault();
      console.log("prevented");
      error.textContent = "キーワードを入力してください";
      errorBox.classList.remove("d-none");
    } else {
      error.textContent = "";
      errorBox.classList.add("d-none");
    }
  });
});