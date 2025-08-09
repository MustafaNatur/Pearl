// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', () => {
    // Initialize the pearl sphere logo
    const pearlLogo = new PearlSphere(document.getElementById('pearl-logo'), {
        size: 1.4,  // Increased sphere size
        baseColor: '#ffffff',
        accentColor: '#e302f7',
        autoRotate: true,
        controlsEnabled: false,
        iridescence: 0.5,
        gloss: 0.8,
        pearlShift: 0.3,
        animationSpeed: 1.0
    });

    // Handle scroll-based effects for the logo
    let lastScrollY = window.scrollY;
    window.addEventListener('scroll', () => {
        const currentScrollY = window.scrollY;
        const scrollDirection = currentScrollY > lastScrollY ? 'down' : 'up';
        
        // Adjust pearl properties based on scroll
        if (scrollDirection === 'down') {
            pearlLogo.setProperties({
                iridescence: 0.7,
                pearlShift: 0.4,
                animationSpeed: 1.2
            });
        } else {
            pearlLogo.setProperties({
                iridescence: 0.5,
                pearlShift: 0.3,
                animationSpeed: 0.7
            });
        }
        
        lastScrollY = currentScrollY;
    });

    // Initialize Intersection Observer for animations
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.3
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Observe all animatable elements
    document.querySelectorAll('[data-animate="true"]').forEach(element => {
        observer.observe(element);
    });

    // Handle form submission
    const waitlistForm = document.getElementById('waitlist-form');
    waitlistForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const email = waitlistForm.querySelector('input[type="email"]').value;
        // Here you would typically send this to your backend
        console.log('Waitlist signup:', email);
        // Show success message (you should style this in CSS)
        waitlistForm.innerHTML = '<div class="form-success">Thanks for joining! We\'ll be in touch soon.</div>';
    });
});