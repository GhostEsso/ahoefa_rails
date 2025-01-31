import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submitForm(event) {
    console.log("Formulaire soumis")
    
    // Si le formulaire est invalide, laissez le navigateur gérer la validation
    if (!this.element.checkValidity()) {
      return
    }

    // Empêcher la double soumission
    const submitButton = this.element.querySelector('input[type="submit"]')
    if (submitButton) {
      submitButton.disabled = true
    }
  }
} 