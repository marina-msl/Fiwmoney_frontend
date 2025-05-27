<template>
    <div class="stock-page">
        <form @submit.prevent="addStock" class="stock-form">
        <label for="stockCode">Stock Code:</label>
        <input type="text" id="stockCode" v-model="stockCode" placeHolder="Enter stock code" required/>
        
        <label for="currentPrice">Current Price</label>
        <input type="number" id="currentPrice" v-model="currentPrice" placeHolder="Enter price" required
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
        currentPrice: 0,
        stocks: []
      };
    },
    methods: {
      addStock() {
        const exists = this.stocks.some(stock => stock.code == this.stockCode.toUpperCase());
        if (exists) {
          alert('Stock already exists!');
          return;
        }
        const newStock = { 
          code: this.stockCode.toUpperCase(),
          currentPrice: parseFloat(this.currentPrice), 
          averagePrice: 100
        };
        this.stocks.push(newStock);
        this.stockCode = '';
        this.currentPrice = '';
      }
    }
  }; 
</script>

  <style scoped>

  .stock-page {
  min-height: 100vh;
  background-color: var(--verde-escuro);
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
  }

  .stock-form {
  display: flex;
  flex-direction: column;
  gap: 12px;
  background: var(--cinza);
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 0 10px rgba(0,0,0,0.3);
  width: 100%;
  max-width: 400px;
  }

  .stock-form input {
  padding: 10px;
  font-size: 1em;
  border: 1px solid var(--cinza-claro);
  border-radius: 8px;
  outline: none;
}

.stock-form input:focus {
  border-color: var(--ocre);
}

.stock-form button {
  background-color: var(--ocre);
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