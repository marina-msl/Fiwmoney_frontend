<template>
    <div class="stock-container">
      <div
        v-for="(stock, index) in stocks"
        :key="index"
        class="stock-card"
      >
        <h2>{{ stock.name }}</h2>
        <p><strong>Preço Atual:</strong> R$ {{ stock.currentPrice.toFixed(2) }}</p>
        <p><strong>Preço Médio de Compra:</strong> R$ {{ stock.averagePrice.toFixed(2) }}</p>
        <p><strong>Diferença:</strong> 
           <span :class="getProfit(stock)">
            R$ {{ getDifference(stock).toFixed(2) }} / {{ getPercentage(stock).toFixed(2) }}%
        </span>
        </p>
        <p><strong>Status:</strong> 
          <span :class="getProfit(stock)">
            {{ getStatus(stock) }}
          </span>
        </p>
      </div> 
    </div>
  </template>

<script>
  export default {
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
    },
    methods: {
      getDifference(stock) {
        return stock.currentPrice - stock.averagePrice;
      },
      
      getPercentage(stock) {
        return (this.getDifference(stock) / stock.averagePrice) * 100;
      },
      
      getProfit(stock) {
        return this.getDifference(stock) >= 0 ? "profit" : "loss";
      },

      getStatus(stock) {
         return this.getDifference(stock) >= 0 ? "Lucro! 🟢" : "Prejuízo! 🔴";
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

  .stock-card {
  border: 2px solid #02080f;
  padding: 16px;
  border-radius: 8px;
  background-color: #02010a;
  width: 300px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.6);
  color: #f0f0f0;
  transition: transform 0.2s ease;
}
  
.stock-card:hover {
  transform: scale(1.03);
} 

.profit {
  color: green;
  font-weight: bold;
}

.loss {
  color: red;
  font-weight: bold;
}
</style>
  