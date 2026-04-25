const root = document.getElementById('notify-root');

const maxNotifications = 5;

const icons = {
    primary: 'D',
    success: '✓',
    error: '!',
    warning: '⚠',
    info: 'i',
    cash: '$',
    police: '★'
};

const typeFallback = 'primary';

function sanitizeText(value) {
    if (value === undefined || value === null) {
        return '';
    }

    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

function normalizeType(type) {
    if (!type) {
        return typeFallback;
    }

    if (type === 'inform') {
        return 'info';
    }

    const allowed = [
        'primary',
        'success',
        'error',
        'warning',
        'info',
        'cash',
        'police'
    ];

    return allowed.includes(type) ? type : typeFallback;
}

function removeNotification(element) {
    if (!element || element.classList.contains('exit')) {
        return;
    }

    element.classList.add('exit');

    setTimeout(() => {
        if (element && element.parentNode) {
            element.parentNode.removeChild(element);
        }
    }, 380);
}

function enforceLimit() {
    const notifications = root.querySelectorAll('.notify');

    if (notifications.length <= maxNotifications) {
        return;
    }

    const overflow = notifications.length - maxNotifications;

    for (let i = 0; i < overflow; i++) {
        removeNotification(notifications[i]);
    }
}

function createNotification(data) {
    const type = normalizeType(data.type);
    const title = sanitizeText(data.title || 'Distortionz');
    const message = sanitizeText(data.message || 'Notification');
    const duration = Number(data.duration) > 0 ? Number(data.duration) : 5000;
    const icon = icons[type] || icons[typeFallback];

    const notification = document.createElement('div');

    notification.className = `notify ${type}`;
    notification.innerHTML = `
        <div class="notify-glow"></div>

        <div class="notify-content">
            <div class="notify-icon">${icon}</div>

            <div class="notify-text">
                <div class="notify-title">${title}</div>
                <div class="notify-message">${message}</div>
            </div>
        </div>

        <div class="notify-progress-wrap">
            <div class="notify-progress" style="animation-duration: ${duration}ms;"></div>
        </div>
    `;

    root.appendChild(notification);
    enforceLimit();

    setTimeout(() => {
        removeNotification(notification);
    }, duration);

    return notification;
}

window.addEventListener('message', (event) => {
    const payload = event.data;

    if (!payload || payload.action !== 'notify') {
        return;
    }

    createNotification(payload.data || {});
});