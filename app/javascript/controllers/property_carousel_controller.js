import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "currentIndex", "totalSlides"]

  connect() {
    console.log("PropertyCarousel connected")
    this.currentIndex = 0
    this.showSlide(this.currentIndex)
    this.updateCounters()
  }

  next() {
    console.log("Next clicked")
    const nextIndex = (this.currentIndex + 1) % this.slideTargets.length
    this.showSlide(nextIndex)
    this.currentIndex = nextIndex
    this.updateCounters()
  }

  previous() {
    console.log("Previous clicked")
    const prevIndex = (this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length
    this.showSlide(prevIndex)
    this.currentIndex = prevIndex
    this.updateCounters()
  }

  showSlide(index) {
    this.slideTargets.forEach((slide, i) => {
      if (i === index) {
        slide.classList.remove('hidden')
        slide.classList.add('animate-fade-in')
      } else {
        slide.classList.add('hidden')
        slide.classList.remove('animate-fade-in')
      }
    })
  }

  updateCounters() {
    this.currentIndexTarget.textContent = this.currentIndex + 1
    this.totalSlidesTarget.textContent = this.slideTargets.length
  }
} 