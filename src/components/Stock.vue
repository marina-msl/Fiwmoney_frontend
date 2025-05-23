<template>
    <div class="stock-container">
      <StockCard
        v-for="(stock, index) in stocks"
        :key="index"
        :stock="stock"
        class="stock-card"
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
        stocks: [ 
        {
          name: "PETR4 - Petrobras PN",
          currentPrice: 29.75,
          averagePrice: 28.50,
        },
        {
          name: "VALE3 - Vale ON",
          currentPrice: 65.80,
          averagePrice: 70.00
        },
        {
          name: "ITUB4 - Itaú Unibanco PN",
          currentPrice: 25.00,
          averagePrice: 23.00
        }
      ]
      };
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