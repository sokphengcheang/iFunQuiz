/**
 * iFun Quiz – Promotional site
 * Handles mobile menu and smooth scroll.
 */

(function () {
  'use strict';

  const navToggle = document.querySelector('.nav-toggle');
  const navLinks = document.querySelector('.nav-links');

  if (navToggle && navLinks) {
    navToggle.addEventListener('click', function () {
      navLinks.classList.toggle('is-open');
      navToggle.setAttribute('aria-expanded', navLinks.classList.contains('is-open'));
    });

    // Close menu when a link is clicked (for anchor links)
    navLinks.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        navLinks.classList.remove('is-open');
        navToggle.setAttribute('aria-expanded', 'false');
      });
    });

    // Close menu on escape
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') {
        navLinks.classList.remove('is-open');
        navToggle.setAttribute('aria-expanded', 'false');
      }
    });
  }

  // Optional: subtle fade-in for sections on scroll
  const sections = document.querySelectorAll('.section, .hero');
  const observerOptions = { rootMargin: '-10% 0px -10% 0px', threshold: 0 };

  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
        }
      });
    }, observerOptions);

    sections.forEach(function (section) {
      section.classList.add('animate-on-scroll');
      observer.observe(section);
    });
  }
})();
