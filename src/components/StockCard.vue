<template>
    <div class="stock-card">
        <h2>{{ stock.code }}</h2>
        <p><strong>Preço Atual:</strong> {{ formatCurrency(stock.currentPrice) }}</p>
        <p><strong>Preço Médio:</strong> {{ formatCurrency(stock.averagePrice) }}</p>
        <p><strong>Diferença: </strong>  {{ formatCurrency(getDifference(stock)) }}</p>
        <p><strong>Status: </strong>     {{ getStatus(stock) }}</p>    
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
    
        getStatus(stock) {
         return this.getDifference(stock) >= 0 ? "Esperar 🔴" :  "Comprar! 🟢";
        }

        // getNotify(stock) {
        //     return true;
        // }

    }   
};
</script>

<style scoped>
.stock-card {
  background-color: #161b22;
  color: #c9d1d9;
  padding: 10px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
  width: 230px;
  transition: transform 0.2s ease, box-shadow 0.3s ease;
  border: 1px solid #30363d;
}
  
.stock-card:hover {
  transform: scale(1.10);
}

h2 {
  color: white;
  margin-bottom: 12px;
}

p {
  margin: 6px 0;
  font-size: 1rem;
}

</style>
