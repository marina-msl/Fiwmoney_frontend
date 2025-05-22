<template>
    <div class="stock-card">
      <div
        v-for="(sotck, index) in stocks"
        :key="index"
        class="stock-card"
      >
        <h2>{{ stock.name }}</h2>
        <p><strong>Preço Atual:</strong> R$ {{ stock.currentPrice.toFixed(2) }}</p>
        <p><strong>Preço Médio de Compra:</strong> R$ {{ stock.averagePrice.toFixed(2) }}</p>
        <p><strong>Diferença:</strong> <span :class="profitClass">
        R$ {{ stock.difference.toFixed(2) }} / {{ stock.percentage.toFixed(2) }}%
        </span></p>
        <p><strong>Status:</strong> <span :class="profitClass">{{ stock.status }}</span></p>
      </div> 
    </div>
  </template>

<script>
  export default {
    data() {
      return {
        stock: [ 
        {
          name: "PETR4 - Petrobras PN",
          currentPrice: 29.75,
          averagePrice: 28.50,
          status: "Lucro! 🟢"
        },
        {
          name: "VALE3 - Vale ON",
          currentPrice: 65.80,
          averagePrice: 70.00
        }
      ]
      };
    },
    // computed: {
    //   profitClass() {
    //     return this.stock.difference >= 0 ? "profit" : "loss";
    //   }
    // }
    computed: {
      difference() {
        return this.stock.currentPrice - this.stock.averagePrice;
      },
      
      percentage() {
        return (this.difference / this.stock.averagePrice) * 100;
      },
      
      profitClass() {
        return this.difference >= 0 ? "profit" : "loss";
      },

      status() {
         return this.difference >= 0 ? "Lucro! 🟢" : "Prejuízo! 🔴";
      }
}
  };
  </script>
  
  <style scoped>
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
  