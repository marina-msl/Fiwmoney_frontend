<template>
    <div class="stock-page">
        <form @submit.prevent="addStock" class="stock-form">
        <label for="stockCode">Stock Code:</label>
        <input type="text" id="stockCode" v-model="stockCode" placeHolder="Enter stock code" required/>
        
        <label for="averagePrice">Average Price</label>
        <input type="number" id="averagePrice" v-model="currentPrice" placeHolder="Enter price" required
                step="0.01"/>

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
import StockCard from './StockCard.vue';

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
    methods: {
      async addStock() {
        const exists = this.stocks.some(stock => stock.code == this.stockCode.toUpperCase());
        if (exists) {
          alert('Stock already exists!');
          return;
        }
        const newStock = { 
          code: this.stockCode.toUpperCase(),
          currentPrice: 100, 
          averagePrice: parseFloat(this.averagePrice)
        };
        this.stocks.push(newStock);

        try {
          const response = await fetch('http://localhost:8080/stock', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              code: newStock.code,
              averagePrice: newStock.averagePrice
            })
          });

            if (response.status == 404) {
              alert('Stock not found!');
            } else if (response.status == 500) {
              alert('Internal error!');
            } else if(!response.ok) {
              throw new Error('Failed to save stock');
            }

            alert('Stock saved succesfully');
            
        } catch (error) {
          alert('Error sending stock to backend: ${error.message}');
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

  <style scoped>

.stock-page {
  min-height: 100vh;
  background: linear-gradient(to right, #000428, #004e92); /* corrigido */
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
  flex-wrap: wrap;
  justify-content: center;
  margin-top: 40px;
}

</style>