document.addEventListener('DOMContentLoaded', function() {
    const tabs = document.querySelectorAll('.tabs button');
    const connectionList = document.querySelector('.connection-list');

    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            tabs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            // Add your logic to filter connection list based on the tab clicked
        });
    });
});
