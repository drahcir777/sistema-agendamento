// app/javascript/controllers/phone_mask_controller.js
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input'];

  connect() {
    this.applyMask();
  }

  applyMask() {
    const input = this.inputTarget;
    input.addEventListener('input', () => {
      const cleanedInput = input.value.replace(/\D/g, '');
      const formattedInput = this.formatPhone(cleanedInput);
      input.value = formattedInput;
    });
  }

  formatPhone(number) {
    const length = number.length;
    if (length > 10) {
      return `(${number.slice(0, 2)}) ${number.slice(2, 7)}-${number.slice(7, 11)}`;
    } else if (length > 6) {
      return `(${number.slice(0, 2)}) ${number.slice(2, 6)}-${number.slice(6, 10)}`;
    } else if (length > 2) {
      return `(${number.slice(0, 2)}) ${number.slice(2)}`;
    } else {
      return number;
    }
  }
}