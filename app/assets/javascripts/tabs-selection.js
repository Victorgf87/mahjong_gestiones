document.addEventListener('DOMContentLoaded', function() {
    const tabs = document.querySelectorAll('ul li');
    const tabContents = document.querySelectorAll('.tab-content');

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const tabId = tab.id;
            const contentId = tabId + '-content';

            tabs.forEach(t => t.classList.remove('border-b-2', 'border-blue-500'));
            tabContents.forEach(content => content.classList.add('hidden'));

            tab.classList.add('border-b-2', 'border-blue-500');
            document.getElementById(contentId).classList.remove('hidden');
        });
    });
});
alert("a")