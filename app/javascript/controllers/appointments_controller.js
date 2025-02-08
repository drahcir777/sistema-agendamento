import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["professionalSelect", "dateSelect", "timeSelect"]

  connect() {
    const userId = this.professionalSelectTarget.value
    if (userId) {
      this.loadDatesAndTimes()
    }
  }

  professionalChanged() {
    this.loadDatesAndTimes()
    // Limpa as seleções anteriores
    this.dateSelectTarget.value = ""
    this.timeSelectTarget.innerHTML = '<option value="">Selecione um horário</option>'
  }

  dateChanged() {
    const userId = this.professionalSelectTarget.value
    const selectedDate = this.dateSelectTarget.value
    if (!userId || !selectedDate) return

    this.loadDatesAndTimes(selectedDate)
  }

  loadDatesAndTimes(date = '') {
    const userId = this.professionalSelectTarget.value
    if (!userId) return

    fetch(`/appointments/available_dates_and_times?user_id=${userId}&date=${date}`, {
      headers: {
        "Accept": "application/json"
      }
    })
      .then(response => response.json())
      .then(data => {
        this.updateDates(data.dates)
        this.updateTimes(data.times)
      })
      .catch(error => console.error("Erro ao carregar datas e horários:", error))
  }



  updateDates(dates) {
    const currentSelectedDate = this.dateSelectTarget.value
    this.dateSelectTarget.innerHTML = '<option value="">Selecione uma data</option>'

    dates.forEach(date => {
      const option = document.createElement('option')
      option.value = date
      const dateObj = new Date(date + 'T00:00:00')
      option.textContent = dateObj.toLocaleDateString('pt-BR')

      // Marca a data como selecionada se for a atual
      if (date === currentSelectedDate) {
        option.selected = true
      }

      this.dateSelectTarget.appendChild(option)
    })
  }

  updateTimes(times) {
    this.timeSelectTarget.innerHTML = '<option value="">Selecione um horário</option>'
    times.forEach(time => {
      const option = document.createElement('option')
      option.value = time
      // Formata o horário para o padrão HH:mm
      const [hours, minutes] = time.split(':')
      const formattedTime = `${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`
      option.textContent = formattedTime
      this.timeSelectTarget.appendChild(option)
    })
  }
}