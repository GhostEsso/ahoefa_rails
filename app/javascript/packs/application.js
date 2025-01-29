// Hero Carousel
document.addEventListener('DOMContentLoaded', () => {
  const slides = document.querySelectorAll('.hero-slide');
  const indicators = document.querySelectorAll('#slide-indicators button');
  let currentSlide = 0;
  let interval;

  // Initialize first slide
  slides[0].classList.add('active');

  function goToSlide(n) {
    // Remove active class from current slide and indicator
    slides[currentSlide].classList.remove('active');
    indicators[currentSlide].classList.remove('bg-indigo-600');
    indicators[currentSlide].classList.add('bg-gray-300');

    // Update current slide
    currentSlide = n;

    // Add active class to new slide and indicator
    slides[currentSlide].classList.add('active');
    indicators[currentSlide].classList.remove('bg-gray-300');
    indicators[currentSlide].classList.add('bg-indigo-600');
  }

  // Auto advance slides
  function startSlideshow() {
    interval = setInterval(() => {
      let next = (currentSlide + 1) % slides.length;
      goToSlide(next);
    }, 5000);
  }

  // Add click handlers to indicators
  indicators.forEach((indicator, index) => {
    indicator.addEventListener('click', () => {
      clearInterval(interval);
      goToSlide(index);
      startSlideshow();
    });
  });

  // Start the slideshow
  startSlideshow();
}); 