<template>
    <div>
        <form @submit.prevent="addStock">
        <label for="stockCode">Stock Code:</label>
        <input type="text" id="stockCode" v-model="stockCode" placeHolder="Enter stock code" required/>
        
        <label for="currentPrice">Current Price</label>
        <input type="number" id="currentPrice" v-model="currentPrice" placeHolder="Enter price" required/>

        <button type="submit">Add Stock</button>
    </form>

      <StockCard
        v-for="stock in stocks"
        :key="stock.code"
        :stock="stock"
      />
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
        currentPrice: '',
        stocks: []
      };
    },
    methods: {
      addStock() {
        const newStock = { 
          code: this.stockCode,
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

  .stock-container {
  display: flex;
  gap: 26px;
  flex-wrap: wrap; 
  justify-content: center;
  margin-top: 250px;
  }

</style>