<template>
    <div class="stock-card">
        <h2>{{ stock.name }}</h2>
        <p><strong>Preço Atual:</strong> {{ formatCurrency(stock.currentPrice) }}</p>
        <p><strong>Preço Médio de Compra:</strong> {{ formatCurrency(stock.averagePrice) }}</p>
        <p><strong>Diferença: </strong> 
           <span :class="getProfit(stock)">
           {{ formatCurrency(getDifference(stock)) }} / {{ getPercentage(stock).toFixed(2) }}%
        </span>
        </p>
        <p><strong>Status: </strong> 
          <span :class="getProfit(stock)">
            {{ getStatus(stock) }}
          </span>
        </p>
    </div> 
  </template>

<script>
    export default {
        name: "StockCard", 
        props: {
            stock: {
                type: Object,
                required: true
        }
    },
    methods: {
        formatCurrency(value) {
         return new Intl.NumberFormat('pt-BR', {
         style: 'currency',
         currency: 'BRL'
        }).format(value);
        },

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

<style>

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
