<template>
    <div class="stock-card">
        <h2>{{ stock.code }}</h2>
        <p><strong>Preço Atual:</strong> {{ formatCurrency(stock.currentPrice) }}</p>
        <p><strong>Preço Médio:</strong> {{ formatCurrency(stock.averagePrice) }}</p>
        <p><strong>Diferença: </strong>  {{ formatCurrency(getDifference(stock)) }}</p>
        <p><strong>Status: </strong>     {{ getStatus(stock) }}</p>    
        <p>
          <strong>Notificar: </strong>
          <label class="switch">
          <input type="checkbox" v-model="stock.notify" @change="toggleNotify" />
          <span class="slider"></span>
          </label>
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
    
        getStatus(stock) {
         return this.getDifference(stock) >= 0 ? "Esperar 🔴" :  "Comprar! 🟢";
        },

        async toggleNotify() {
          const notify = {
            code: this.stock.code,
            averagePrice: this.stock.averagePrice,
            notify: this.notify
          };

          try {
            const response = await fetch('http://localhost:8080/notify', {
              method: 'POST',
              headers: {
                'Content-type':'application/json',
              },
              body: JSON.stringify(notify)
            });

            if (!response.ok) {
              throw new Error (`Erro ao atualizar notificação para ${this.stock.code}`);
            }

          } catch (error) {
            alert(`Erro: ${error.message}`);
            // Revert toggle state on failure
            this.notify = !this.notify;
          }
        }
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

.switch {
  position: relative;
  display: inline-block;
  width: 33px;
  height: 18px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  background-color: #ccc;
  transition: 0.4s;
  border-radius: 15px;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

.slider:before {
  position: absolute;
  content: "";
  height: 10px;
  width: 10px;
  border-radius: 50%;
  background-color: white;
  transition: 0.2s;
  top: 3px;
  left: 3px;
}

input:checked + .slider {
  background-color: #1abc9c;
}

input:checked + .slider:before {
  transform: translateX(18px);
}

</style>
