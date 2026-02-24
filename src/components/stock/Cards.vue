<script>
import StockService from '@/services/StockService'

export default {
  name: 'StockCard',
  props: {
    stock: {
      type: Object,
      required: true,
    },
  },
  emits: ['delete'],
  data() {
    return {
      editingAverage: false,
      editedAveragePrice: this.stock.averagePrice,
    }
  },
  watch: {
    'stock.averagePrice'(newVal) {
      if (!this.editingAverage) {
        this.editedAveragePrice = newVal
      }
    },
  },
  methods: {
    formatCurrency(value) {
      return new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL',
      }).format(value)
    },

    getDifference(stock) {
      return stock.currentPrice - stock.averagePrice
    },

    getStatus(stock) {
      return this.getDifference(stock) >= 0 ? 'Esperar 🔴' : 'Comprar! 🟢'
    },

    async toggleNotify() {
      const code = this.stock.code
      const newNotify = this.stock.notify

      try {
        await StockService.setNotify(code, newNotify)
      }
      catch (error) {
        alert(`Erro: ${error.message}`)
        this.stock.notify = !newNotify
      }
    },

    startEditAverage() {
      this.editedAveragePrice = this.stock.averagePrice
      this.editingAverage = true
    },

    cancelEditAverage() {
      this.editingAverage = false
      this.editedAveragePrice = this.stock.averagePrice
    },

    async saveAveragePrice() {
      const walletId = localStorage.getItem('walletId')
      const parsed = Number.parseFloat(this.editedAveragePrice)
      if (Number.isNaN(parsed)) {
        // eslint-disable-next-line no-alert
        alert('Please enter a valid number for average price.')
        return
      }

      try {
        await StockService.updateAveragePrice(walletId, this.stock.code, parsed)
        this.stock.averagePrice = parsed
        this.editingAverage = false
      }
      catch (error) {
        // eslint-disable-next-line no-alert
        alert(`Error updating average price: ${error.message}`)
      }
    },
  },
}
</script>

<template>
  <div class="stock-card">
    <h2>{{ stock.code }}</h2>
    <p><strong>Preço Atual:</strong> {{ formatCurrency(stock.currentPrice) }}</p>
    <p>
      <strong>Preço Médio:</strong>
      <span v-if="!editingAverage">
        {{ formatCurrency(stock.averagePrice) }}
        <button
          type="button"
          class="edit-average-btn"
          @click="startEditAverage"
        >
          Editar
        </button>
      </span>
      <span
        v-else
        class="edit-average"
      >
        <input
          v-model.number="editedAveragePrice"
          type="number"
          step="0.01"
          class="edit-average-input"
        >
        <button
          type="button"
          class="save-average-btn"
          @click="saveAveragePrice"
        >
          Salvar
        </button>
        <button
          type="button"
          class="cancel-average-btn"
          @click="cancelEditAverage"
        >
          Cancelar
        </button>
      </span>
    </p>
    <p><strong>Diferença: </strong>  {{ formatCurrency(getDifference(stock)) }}</p>
    <p><strong>Status: </strong>     {{ getStatus(stock) }}</p>
    <p>
      <strong>Notificar: </strong>
      <label class="switch">
        <input v-model="stock.notify" type="checkbox" @change="toggleNotify">
        <span class="slider" />
      </label>
    </p>
    <button type="button" class="delete-btn" title="Excluir" @click="$emit('delete', stock)">
      Excluir
    </button>
  </div>
</template>

<style scoped>
.stock-card {
  background-color: #161b22;
  color: #c9d1d9;
  padding: 10px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
  width: 230px;
  transition: transform 0.2s ease, box-shadow 0.3s ease;
  border: 1px solid #30363d;
}

.stock-card:hover {
  transform: scale(1.10);
}

h2 {
  color: white;
  margin-bottom: 12px;
}

p {
  margin: 6px 0;
  font-size: 1rem;
}

.switch {
  position: relative;
  display: inline-block;
  width: 33px;
  height: 18px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  background-color: #ccc;
  transition: 0.4s;
  border-radius: 15px;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

.slider:before {
  position: absolute;
  content: "";
  height: 10px;
  width: 10px;
  border-radius: 50%;
  background-color: white;
  transition: 0.2s;
  top: 3px;
  left: 3px;
}

input:checked + .slider {
  background-color: #1abc9c;
}

input:checked + .slider:before {
  transform: translateX(18px);
}

.delete-btn {
  margin-top: 10px;
  width: 100%;
  padding: 6px 12px;
  border: none;
  border-radius: 8px;
  background-color: #e74c3c;
  color: white;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.delete-btn:hover {
  background-color: #c0392b;
}

.edit-average {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  margin-left: 8px;
}

.edit-average-input {
  width: 80px;
  padding: 2px 6px;
  border-radius: 6px;
  border: 1px solid #30363d;
  background-color: #111827;
  color: #c9d1d9;
}

.edit-average-btn,
.save-average-btn,
.cancel-average-btn {
  margin-left: 8px;
  padding: 2px 8px;
  border-radius: 6px;
  border: none;
  font-size: 0.8rem;
  cursor: pointer;
}

.edit-average-btn {
  background-color: #1abc9c;
  color: white;
}

.save-average-btn {
  background-color: #1abc9c;
  color: white;
}

.cancel-average-btn {
  background-color: #555;
  color: white;
}
</style>
