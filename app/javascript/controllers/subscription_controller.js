import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["priceDisplay"]
  static values = {
    monthlyPrice: Number,
    annualDiscount: Number
  }

  toggleAnnual(event) {
    const isAnnual = event.target.checked
    const monthlyPrice = this.monthlyPriceValue
    const discount = this.annualDiscountValue

    if (isAnnual) {
      const annualPrice = Math.round(monthlyPrice * 12 * (1 - discount))
      this.priceDisplayTarget.textContent = `${annualPrice} FCFA/an (économisez ${Math.round(monthlyPrice * 12 * discount)} FCFA)`
    } else {
      this.priceDisplayTarget.textContent = `${monthlyPrice * 12} FCFA/an`
    }
  }
}

// Contrôleur pour la gestion des prix d'abonnement
const ANNUAL_DISCOUNT = 0.05; // 5% de réduction

document.addEventListener('DOMContentLoaded', function() {
  // Sélecteurs
  const planInputs = document.querySelectorAll('input[type="radio"][name="user[plan]"]');
  const annualCheckbox = document.querySelector('input[name="user[annual]"]');
  const priceDisplay = document.querySelector('[data-subscription-target="priceDisplay"]');

  // Fonction pour formater le prix
  function formatPrice(price) {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency: 'XOF',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(price).replace('XOF', 'FCFA');
  }

  // Fonction pour mettre à jour l'affichage du prix
  function updatePriceDisplay() {
    const selectedPlan = document.querySelector('input[type="radio"][name="user[plan]"]:checked');
    if (!selectedPlan) return;

    const monthlyPrice = parseInt(selectedPlan.dataset.price);
    const isAnnual = annualCheckbox.checked;

    let finalPrice;
    if (isAnnual) {
      finalPrice = monthlyPrice * 12 * (1 - ANNUAL_DISCOUNT);
      priceDisplay.textContent = `${formatPrice(finalPrice)} FCFA/an`;
    } else {
      finalPrice = monthlyPrice;
      priceDisplay.textContent = `${formatPrice(finalPrice)} FCFA/mois`;
    }
  }

  // Écouteurs d'événements
  planInputs.forEach(input => {
    input.addEventListener('change', updatePriceDisplay);
  });

  annualCheckbox.addEventListener('change', updatePriceDisplay);

  // Initialisation
  updatePriceDisplay();
}); 