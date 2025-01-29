import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "properties", "property", "form"]

  connect() {
    console.log("Search controller connected")
    this.propertyTargets.forEach(property => {
      property.classList.add("transition-all", "duration-300", "ease-in-out")
    })
  }

  initialize() {
    this.submit = this.debounce(this.submit.bind(this), 300)
  }

  search() {
    this.submit()
  }

  submit() {
    const query = this.inputTarget.value.toLowerCase().trim()
    console.log("Recherche pour:", query)
    
    let matchCount = 0
    
    this.propertyTargets.forEach((property) => {
      const title = property.dataset.title?.toLowerCase() || ""
      const city = property.dataset.city?.toLowerCase() || ""
      const description = property.dataset.description?.toLowerCase() || ""
      const type = property.dataset.propertyType?.toLowerCase() || ""
      
      const matches = title.includes(query) || 
                     city.includes(query) || 
                     description.includes(query) ||
                     type.includes(query)
      
      if (matches) {
        property.classList.remove("hidden", "opacity-0")
        property.classList.add("opacity-100")
        matchCount++
      } else {
        property.classList.add("opacity-0")
        setTimeout(() => {
          property.classList.add("hidden")
        }, 300)
      }
    })
    
    console.log(`Trouvé ${matchCount} propriétés correspondantes`)
  }

  // Fonction utilitaire pour limiter le nombre de requêtes
  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }
} 