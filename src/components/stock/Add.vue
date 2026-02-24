<script>
import StockCard from '@/components/stock/Cards.vue'
import StockService from '@/services/StockService'

export default {
  components: {
    StockCard,
  },
  data() {
    return {
      stockCode: '',
      averagePrice: 0,
      stocks: [],
      statusMessage: '',
      statusType: '',
    }
  },
  mounted() {
    const walletId = localStorage.getItem('walletId')
    StockService.fetchStocks(walletId)
      .then((wallet) => { this.stocks = wallet.stocks })
      .catch((error) => {
        console.error('Error loading stocks:', error)
        if (error.status === 403) {
          localStorage.removeItem('token')
          localStorage.removeItem('walletId')
          localStorage.removeItem('username')
          this.$router.push('/login')
        }
        else {
          this.statusMessage = error.message
        }
      })
  },

  methods: {
    async addStock() {
      const exists = this.stocks.some(stock => stock.code === this.stockCode.toUpperCase())
      if (exists) {
        // eslint-disable-next-line no-alert
        alert('Stock already exists!')
        return
      }

      const newStock = {
        code: this.stockCode.trim().toUpperCase(),
        averagePrice: Number.parseFloat(this.averagePrice),
      }

      const walletId = localStorage.getItem('walletId')
      try {
        const stockResponse = await StockService.addStock(walletId, newStock)
        this.stocks.push({ ...stockResponse, code: stockResponse.code ?? newStock.code })
        // eslint-disable-next-line no-alert
        alert('Stock saved succesfully')
      }
      catch (error) {
        if (error.status === 403) {
          try {
            const retryResponse = await StockService.addStock(walletId, newStock)
            this.stocks.push({ ...retryResponse, code: retryResponse.code ?? newStock.code })
            // eslint-disable-next-line no-alert
            alert('Stock saved successfully')
          }
          catch (retryError) {
            this.statusMessage = retryError.message
            // eslint-disable-next-line no-alert
            alert(`Error sending stock to backend: ${retryError.message}`)
            console.error('Add stock error:', retryError)
          }
        }
        else {
          this.statusMessage = error.message
          // eslint-disable-next-line no-alert
          alert(`Error sending stock to backend: ${error.message}`)
          console.error('Add stock error:', error)
        }
      }
      // Reset form
      this.stockCode = ''
      this.averagePrice = 0
    },

    async removeStock(stock) {
      const code = stock.code

      if (!code) {
        // eslint-disable-next-line no-alert
        alert('Cannot delete this stock because it has no code.')
        return
      }

      // eslint-disable-next-line no-alert
      if (!confirm(`Excluir a stock ${code}?`)) {
        return
      }

      const walletId = localStorage.getItem('walletId')
      try {
        await StockService.deleteStock(walletId, code)
        this.stocks = this.stocks.filter(s => s !== stock)
      }
      catch (error) {
        // eslint-disable-next-line no-alert
        alert(`Erro ao excluir: ${error.message}`)
      }
    },
  },
}
</script>

<template>
  <div class="stock-page">
    <form class="stock-form" @submit.prevent="addStock">
      <label for="stockCode">Stock Code:</label>
      <input id="stockCode" v-model="stockCode" type="text" placeholde="Enter stock code" required>

      <label for="averagePrice">Average Price</label>
      <input id="averagePrice" v-model="averagePrice" type="number" placeholde="Enter the stock average price" required step="0.01">

      <button type="submit">
        Add Stock
      </button>
    </form>

    <div class="stock-container">
      <StockCard
        v-for="stock in stocks"
        :key="stock.code"
        :stock="stock"
        @delete="removeStock"
      />
    </div>
  </div>
</template>

<style>
.stock-page {
  min-height: 100vh;
  background: linear-gradient(to right, #000428, #004e92);
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
}

.stock-form {
  display: flex;
  flex-direction: column;
  gap: 12px;
  background: #000428;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 0 10px rgba(0,0,0,0.3);
  width: 100%;
  max-width: 400px;
}

.stock-form label {
  font-weight: bold;
  color: var(--branco);
}

.stock-form input {
  padding: 10px;
  font-size: 1em;
  border: 1px solid var(--cinza-claro);
  border-radius: 8px;
  background-color: #111827;
  color: var(--branco);
}

.stock-form input::placeholder {
  color: #9ca3af;
}

.stock-form input:focus {
  border-color: var(--ocre);
}

.stock-form button {
  background-color: #1abc9c;
  color: var(--branco);
  font-weight: bold;
  padding: 10px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.stock-form button:hover {
  background-color: var(--coral);
}

.stock-container {
  display: flex;
  gap: 20px;
  overflow-x: auto;
  padding: 20px 0;
  width: 100%;
  scroll-snap-type: x mandatory;
}

.stock-container > * {
  flex: 0 0 auto;
  scroll-snap-align: start;
}

.stock-container::-webkit-scrollbar {
  height: 8px;
}

.stock-container::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 8px;
}

.stock-container::-webkit-scrollbar-track {
  background: #1e1e2f;

}
</style>
