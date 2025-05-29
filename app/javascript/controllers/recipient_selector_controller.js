import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recipient-selector"
export default class extends Controller {
  static targets = ["userRadio", "communityRadio", "userDropdown", "communityDropdown", "receiverIdField"]

  connect() {
    // Initialize the dropdowns based on the default checked radio
    this.toggleRecipientDropdowns()

    // Set up event listener for modal showing
    const modalTrigger = document.querySelector('[data-modal-toggle="send-money-modal"]')
    if (modalTrigger) {
      modalTrigger.addEventListener('click', () => {
        setTimeout(() => {
          this.toggleRecipientDropdowns()
        }, 100)
      })
    }

    // Initialize the receiver_id hidden field
    this.updateSelectedValue()
  }

  toggleType() {
    this.toggleRecipientDropdowns()
    this.updateSelectedValue()
  }

  toggleRecipientDropdowns() {
    if (this.userRadioTarget.checked) {
      this.userDropdownTarget.classList.remove('hidden')
      this.communityDropdownTarget.classList.add('hidden')
      this.communityDropdownTarget.value = ""
    } else {
      this.userDropdownTarget.classList.add('hidden')
      this.userDropdownTarget.value = ""
      this.communityDropdownTarget.classList.remove('hidden')
    }
  }

  updateSelectedValue() {
    // Update the hidden receiver_id field with the appropriate value
    if (this.userRadioTarget.checked && this.userDropdownTarget.value) {
      this.receiverIdFieldTarget.value = this.userDropdownTarget.value
    } else if (this.communityRadioTarget.checked && this.communityDropdownTarget.value) {
      this.receiverIdFieldTarget.value = this.communityDropdownTarget.value
    } else {
      this.receiverIdFieldTarget.value = ""
    }
  }
}
