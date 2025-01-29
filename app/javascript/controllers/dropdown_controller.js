import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["container", "menu"]

  connect() {
    console.log("Dropdown controller connected")
    // Ajouter un event listener pour fermer le dropdown quand on clique en dehors
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    // Nettoyer l'event listener quand le contrôleur est déconnecté
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    console.log("Toggle clicked")
    this.menuTarget.classList.toggle('hidden')
  }

  handleClickOutside(event) {
    if (!this.containerTarget.contains(event.target)) {
      this.menuTarget.classList.add('hidden')
    }
  }
}
