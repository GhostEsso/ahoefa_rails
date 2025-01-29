import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide"]

  connect() {
    console.log("Carousel connected", this.slideTargets)
    this.currentIndex = 0
    this.showCurrentSlide()
    this.startAutoSlide()
  }

  disconnect() {
    this.stopAutoSlide()
  }

  startAutoSlide() {
    this.slideInterval = setInterval(() => {
      this.next()
    }, 5000)
  }

  stopAutoSlide() {
    if (this.slideInterval) {
      clearInterval(this.slideInterval)
    }
  }

  next() {
    this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((element, index) => {
      if (index === this.currentIndex) {
        element.classList.remove('hidden')
      } else {
        element.classList.add('hidden')
      }
    })
  }
} 