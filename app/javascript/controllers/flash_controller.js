import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.messageTargets.forEach(message => {
      setTimeout(() => {
        message.classList.add('transition', 'duration-500', 'opacity-0')
        setTimeout(() => {
          message.remove()
        }, 500)
      }, 3000)
    })
  }
} 