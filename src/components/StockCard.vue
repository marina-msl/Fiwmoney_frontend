<template>
    <div class="stock-card">
        <h2>{{ stock.code }}</h2>
        <p><strong>Preço Atual:</strong> {{ formatCurrency(stock.currentPrice) }}</p>
        <p><strong>Preço Médio:</strong> {{ formatCurrency(stock.averagePrice) }}</p>
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
  background-color: #161b22;
  color: #c9d1d9;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
  width: 320px;
  transition: transform 0.2s ease, box-shadow 0.3s ease;
  border: 1px solid #30363d;
}
  
.stock-card:hover {
  transform: scale(1.02);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.5);
}

h2 {
  color: white;
  margin-bottom: 12px;
}

p {
  margin: 6px 0;
  font-size: 1rem;
}

.profit {
  color: #3fb950;
  font-weight: 600;
}

.loss {
  color: #f85149;
  font-weight: 600;
}
</style>
