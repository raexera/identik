document.querySelectorAll(".card button").forEach((button) => {
  button.addEventListener("click", function () {
    const usernameInput = this.previousElementSibling.value;
    if (usernameInput) {
      alert(`Connecting to ${usernameInput}`);
    } else {
      alert("Please enter a username");
    }
  });
});
