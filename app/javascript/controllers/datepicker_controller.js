import { Controller } from "@hotwired/stimulus"
import flatpickr from "https://esm.sh/flatpickr@4.6.13?standalone"
import { Portuguese } from "https://esm.sh/flatpickr@4.6.13/dist/l10n/pt?standalone"

export default class extends Controller {
  static targets = ["details"]
  static values = {
    type: String, disable: Array,
    mode: { type: String, default: "single" },
    dateFormat: { type: String, default: "d-m-Y" },
    dateTimeFormat: { type: String, default: "d-m-Y H:i" },
  }

  connect() {
    const baseConfig = {
      locale: Portuguese,
      ...this.#baseOptions
    }

    if (this.typeValue == "time") {
      this.flatpickr = flatpickr(this.element, { ...this.#timeOptions, ...baseConfig })
    } else if (this.typeValue == "datetime") {
      this.flatpickr = flatpickr(this.element, { ...this.#dateTimeOptions, ...baseConfig })
    } else {
      this.flatpickr = flatpickr(this.element, { ...this.#basicOptions, ...baseConfig })
    }
  }

  disconnect() {
    this.flatpickr.destroy()
  }

  get #timeOptions() {
    return { dateFormat: "H:i", enableTime: true, noCalendar: true }
  }

  get #dateTimeOptions() {
    return { ...this.#baseOptions, altFormat: this.dateTimeFormatValue, dateFormat: "Y-m-d H:i", enableTime: true }
  }

  get #basicOptions() {
    return { ...this.#baseOptions, altFormat: this.dateFormatValue, dateFormat: "Y-m-d" }
  }

  get #baseOptions() {
    return { altInput: true, disable: this.disableValue, mode: this.modeValue }
  }
}
