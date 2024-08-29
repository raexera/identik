document.addEventListener("DOMContentLoaded", () => {
    document.querySelector(".delete-account").addEventListener("click", () => {
        if (confirm("Apakah Anda yakin ingin menghapus akun ini?")) {
            alert("Akun telah dihapus.");
            // Tambahkan logika untuk menghapus akun di sini.
        }
    });

    document.querySelector(".send-invitation").addEventListener("click", () => {
        const emailInput = document.querySelector("input[type='email']");
        if (emailInput.value) {
            alert(`Undangan telah dikirim ke ${emailInput.value}`);
            // Tambahkan logika untuk mengirim undangan di sini.
        } else {
            alert("Silakan masukkan alamat email yang valid.");
        }
    });

    document.querySelector(".upgrade-button").addEventListener("click", () => {
        alert("Anda akan diarahkan untuk meng-upgrade.");
        // Tambahkan logika untuk meng-upgrade di sini.
    });
});
