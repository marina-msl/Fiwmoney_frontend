<template>
  <div class="stock-page">
    <form @submit.prevent="addStock" class="stock-form">
      <label for="stockCode">Stock Code:</label>
      <input type="text" id="stockCode" v-model="stockCode" placeholde="Enter stock code" required/>
        
      <label for="averagePrice">Average Price</label>
      <input type="number" id="averagePrice" v-model="averagePrice" placeholde="Enter the stock average price" required step="0.01"/>

      <button type="submit">Add Stock</button>
    </form>

    <div class="stock-container">
      <StockCard
        v-for="stock in stocks"
        :key="stock.code"
        :stock="stock"
      />
    </div>
  </div>
</template>

<script>
import StockCard from './Cards.vue';
import StockService from '../../services/StockService'

  export default {
    components: { 
      StockCard
    },
    data() {
      return {
        stockCode: '',
        averagePrice: 0,
        stocks: [],
        statusMessage: '',
        statusType: ''
      };
    },
    mounted() {
      StockService.fetchStocks()
        .then(stocks => this.stocks = stocks)
        .catch(error => console.error(`Error loading stocks :`, error));
    },
  
    methods: {
      async addStock() {
        const exists = this.stocks.some(stock => stock.code == this.stockCode.toUpperCase());
        if (exists) {
          alert('Stock already exists!');
          return;
        }

        const newStock = { 
          code: this.stockCode.trim().toUpperCase(),
          averagePrice: parseFloat(this.averagePrice)
        };

        try {
          const response = await fetch('http://localhost:8080/stock', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(newStock)
          });

            if (response.status == 404) {
              alert('Stock not found!');
              return;

            } else if (response.status == 500) {
              alert('Internal error!');
              return;

            } else if(!response.ok) {
              throw new Error('Failed to save stock');
            }

            const stockResponse = await response.json();
            this.stocks.push(stockResponse);
            alert('Stock saved succesfully');

        } catch (error) {
          alert(`Error sending stock to backend: ${error.message}`);
          this.statusMessage = error.message;
          console.log(this.statusMessage);
        }

        //Reset form
        this.stockCode =  '';
        this.averagePrice = 0;
      }
    }
  }
</script>

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