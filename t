[1mdiff --git a/src/Dockerfile b/src/Dockerfile[m
[1mindex 88b5236..e917d67 100644[m
[1m--- a/src/Dockerfile[m
[1m+++ b/src/Dockerfile[m
[36m@@ -2,5 +2,5 @@[m [mFROM node:18[m
 WORKDIR /app[m
 COPY . .[m
 RUN npm install && npm run build[m
[31m-EXPOSE 80[m
[32m+[m[32mEXPOSE 3000[m
 CMD ["npx", "serve", "-s", "dist"][m
\ No newline at end of file[m
[1mdiff --git a/src/components/Stock.vue b/src/components/Stock.vue[m
[1mindex a9995e4..23b3d1f 100644[m
[1m--- a/src/components/Stock.vue[m
[1m+++ b/src/components/Stock.vue[m
[36m@@ -1,159 +1,173 @@[m
[31m-<template>[m
[31m-    <div class="stock-page">[m
[31m-        <form @submit.prevent="addStock" class="stock-form">[m
[31m-[m
[31m-        <label for="stockCode">Stock Code:</label>[m
[31m-        <input type="text" id="stockCode" v-model="stockCode" placeHolder="Enter stock code" required/>[m
[31m-        [m
[31m-        <label for="averagePrice">Average Price</label>[m
[31m-        <input type="number" id="averagePrice" v-model="averagePrice" placeHolder="Enter the stock average price" required step="0.01"/>[m
[31m-[m
[31m-        <button type="submit">Add Stock</button>[m
[31m-    </form>[m
[31m-[m
[31m-    <div class="stock-container">[m
[31m-      <StockCard[m
[31m-        v-for="stock in stocks"[m
[31m-        :key="stock.code"[m
[31m-        :stock="stock"[m
[31m-      />[m
[31m-    </div>[m
[31m-    </div>[m
[31m-  </template>[m
[31m-[m
[31m-<script>[m
[31m-import StockCard from './StockCard.vue';[m
[31m-[m
[31m-  export default {[m
[31m-    components: { [m
[31m-      StockCard[m
[31m-    },[m
[31m-    data() {[m
[31m-      return {[m
[31m-        stockCode: '',[m
[31m-        averagePrice: 0,[m
[31m-        stocks: [],[m
[31m-        statusMessage: '',[m
[31m-        statusType: ''[m
[31m-      };[m
[31m-    },[m
[31m-    methods: {[m
[31m-      async addStock() {[m
[31m-        const exists = this.stocks.some(stock => stock.code == this.stockCode.toUpperCase());[m
[31m-        if (exists) {[m
[31m-          alert('Stock already exists!');[m
[31m-          return;[m
[31m-        }[m
[31m-[m
[31m-        const newStock = { [m
[31m-          code: this.stockCode.toUpperCase(),[m
[31m-          averagePrice: parseFloat(this.averagePrice)[m
[32m+[m[32m  <template>[m
[32m+[m[32m      <div class="stock-page">[m
[32m+[m[32m          <form @submit.prevent="addStock" class="stock-form">[m
[32m+[m
[32m+[m[32m          <label for="stockCode">Stock Code:</label>[m
[32m+[m[32m          <input type="text" id="stockCode" v-model="stockCode" placeHolder="Enter stock code" required/>[m
[32m+[m[41m          [m
[32m+[m[32m          <label for="averagePrice">Average Price</label>[m
[32m+[m[32m          <input type="number" id="averagePrice" v-model="averagePrice" placeHolder="Enter the stock average price" required step="0.01"/>[m
[32m+[m
[32m+[m[32m          <button type="submit">Add Stock</button>[m
[32m+[m[32m      </form>[m
[32m+[m
[32m+[m[32m      <div class="stock-container">[m
[32m+[m[32m        <StockCard[m
[32m+[m[32m          v-for="stock in stocks"[m
[32m+[m[32m          :key="stock.code"[m
[32m+[m[32m          :stock="stock"[m
[32m+[m[32m        />[m
[32m+[m[32m      </div>[m
[32m+[m[32m      </div>[m
[32m+[m[32m    </template>[m
[32m+[m
[32m+[m[32m  <script>[m
[32m+[m[32m  import StockCard from './StockCard.vue';[m
[32m+[m
[32m+[m[32m    export default {[m
[32m+[m[32m      components: {[m[41m [m
[32m+[m[32m        StockCard[m
[32m+[m[32m      },[m
[32m+[m[32m      data() {[m
[32m+[m[32m        return {[m
[32m+[m[32m          stockCode: '',[m
[32m+[m[32m          averagePrice: 0,[m
[32m+[m[32m          stocks: [],[m
[32m+[m[32m          statusMessage: '',[m
[32m+[m[32m          statusType: ''[m
         };[m
[31m-[m
[31m-        try {[m
[31m-          const response = await fetch('http://localhost:8080/stock', {[m
[31m-            method: 'POST',[m
[31m-            headers: {[m
[31m-              'Content-Type': 'application/json'[m
[31m-            },[m
[31m-            body: JSON.stringify(newStock)[m
[31m-          });[m
[31m-[m
[31m-            if (response.status == 404) {[m
[31m-              alert('Stock not found!');[m
[31m-              return;[m
[31m-[m
[31m-            } else if (response.status == 500) {[m
[31m-              alert('Internal error!');[m
[31m-              return;[m
[31m-[m
[31m-            } else if(!response.ok) {[m
[31m-              throw new Error('Failed to save stock');[m
[31m-            }[m
[31m-[m
[31m-            const stockResponse = await response.json();[m
[31m-            this.stocks.push(stockResponse);[m
[31m-            alert('Stock saved succesfully');[m
[31m-[m
[31m-        } catch (error) {[m
[31m-          alert('Error sending stock to backend: ${error.message}');[m
[31m-          this.statusMessage = error.message;[m
[31m-          console.log(this.statusMessage);[m
[32m+[m[32m      },[m
[32m+[m[32m      mounted() {[m
[32m+[m[32m        this.fetchStockData();[m
[32m+[m[32m      },[m
[32m+[m[32m      methods: {[m
[32m+[m[32m        async fetchStockData() {[m
[32m+[m[32m          try {[m
[32m+[m[32m            const response = await fetch("http://localhost:8080/stocks");[m
[32m+[m[32m            if (!response.ok) throw new Error ("Faile to fetch stock data");[m
[32m+[m[32m            this.stocks = await response.json();[m
[32m+[m[41m            [m
[32m+[m[32m          } catch(error) {[m
[32m+[m[32m              console.error("Error fetching stock data: " , error);[m
[32m+[m[32m          }[m
[32m+[m
[32m+[m[32m        },[m
[32m+[m[32m        async addStock() {[m
[32m+[m[32m          const exists = this.stocks.some(stock => stock.code == this.stockCode.toUpperCase());[m
[32m+[m[32m          if (exists) {[m
[32m+[m[32m            alert('Stock already exists!');[m
[32m+[m[32m            return;[m
[32m+[m[32m          }[m
[32m+[m
[32m+[m[32m          const newStock = {[m[41m [m
[32m+[m[32m            code: this.stockCode.toUpperCase(),[m
[32m+[m[32m            averagePrice: parseFloat(this.averagePrice)[m
[32m+[m[32m          };[m
[32m+[m
[32m+[m[32m          try {[m
[32m+[m[32m            const response = await fetch('http://localhost:8080/stock', {[m
[32m+[m[32m              method: 'POST',[m
[32m+[m[32m              headers: {[m
[32m+[m[32m                'Content-Type': 'application/json'[m
[32m+[m[32m              },[m
[32m+[m[32m              body: JSON.stringify(newStock)[m
[32m+[m[32m            });[m
[32m+[m
[32m+[m[32m              if (response.status == 404) {[m
[32m+[m[32m                alert('Stock not found!');[m
[32m+[m[32m                return;[m
[32m+[m
[32m+[m[32m              } else if (response.status == 500) {[m
[32m+[m[32m                alert('Internal error!');[m
[32m+[m[32m                return;[m
[32m+[m
[32m+[m[32m              } else if(!response.ok) {[m
[32m+[m[32m                throw new Error('Failed to save stock');[m
[32m+[m[32m              }[m
[32m+[m
[32m+[m[32m              const stockResponse = await response.json();[m
[32m+[m[32m              this.stocks.push(stockResponse);[m
[32m+[m[32m              alert('Stock saved succesfully');[m
[32m+[m
[32m+[m[32m          } catch (error) {[m
[32m+[m[32m            alert(`Error sending stock to backend: ${error.message}`);[m
[32m+[m[32m            this.statusMessage = error.message;[m
[32m+[m[32m            console.log(this.statusMessage);[m
[32m+[m[32m          }[m
[32m+[m
[32m+[m[32m          //Reset form[m
[32m+[m[32m          this.stockCode =  '';[m
[32m+[m[32m          this.averagePrice = 0;[m
         }[m
[31m-[m
[31m-        //Reset form[m
[31m-        this.stockCode =  '';[m
[31m-        this.averagePrice = 0;[m
       }[m
     }[m
[32m+[m[32m  </script>[m
[32m+[m
[32m+[m[32m  <style>[m
[32m+[m
[32m+[m[32m  .stock-page {[m
[32m+[m[32m    min-height: 100vh;[m
[32m+[m[32m    background: linear-gradient(to right, #000428, #004e92);[m
[32m+[m[32m    display: flex;[m
[32m+[m[32m    flex-direction: column;[m
[32m+[m[32m    align-items: center;[m
[32m+[m[32m    padding: 40px 20px;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .stock-form {[m
[32m+[m[32m    display: flex;[m
[32m+[m[32m    flex-direction: column;[m
[32m+[m[32m    gap: 12px;[m
[32m+[m[32m    background: #000428;[m
[32m+[m[32m    padding: 24px;[m
[32m+[m[32m    border-radius: 12px;[m
[32m+[m[32m    box-shadow: 0 0 10px rgba(0,0,0,0.3);[m
[32m+[m[32m    width: 100%;[m
[32m+[m[32m    max-width: 400px;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .stock-form label {[m
[32m+[m[32m    font-weight: bold;[m
[32m+[m[32m    color: var(--branco);[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .stock-form input {[m
[32m+[m[32m    padding: 10px;[m
[32m+[m[32m    font-size: 1em;[m
[32m+[m[32m    border: 1px solid var(--cinza-claro);[m
[32m+[m[32m    border-radius: 8px;[m
[32m+[m[32m    background-color: #111827;[m
[32m+[m[32m    color: var(--branco);[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .stock-form input::placeholder {[m
[32m+[m[32m    color: #9ca3af;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .stock-form input:focus {[m
[32m+[m[32m    border-color: var(--ocre);[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .stock-form button {[m
[32m+[m[32m    background-color: #1abc9c;[m
[32m+[m[32m    color: var(--branco);[m
[32m+[m[32m    font-weight: bold;[m
[32m+[m[32m    padding: 10px;[m
[32m+[m[32m    border: none;[m
[32m+[m[32m    border-radius: 8px;[m
[32m+[m[32m    cursor: pointer;[m
[32m+[m[32m    transition: background 0.2s ease;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .stock-form button:hover {[m
[32m+[m[32m    background-color: var(--coral);[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .stock-container {[m
[32m+[m[32m    display: flex;[m
[32m+[m[32m    gap: 20px;[m
[32m+[m[32m    flex-wrap: wrap;[m
[32m+[m[32m    justify-content: center;[m
[32m+[m[32m    margin-top: 40px;[m
   }[m
[31m-</script>[m
[31m-[m
[31m-<style>[m
[31m-[m
[31m-.stock-page {[m
[31m-  min-height: 100vh;[m
[31m-  background: linear-gradient(to right, #000428, #004e92);[m
[31m-  display: flex;[m
[31m-  flex-direction: column;[m
[31m-  align-items: center;[m
[31m-  padding: 40px 20px;[m
[31m-}[m
[31m-[m
[31m-.stock-form {[m
[31m-  display: flex;[m
[31m-  flex-direction: column;[m
[31m-  gap: 12px;[m
[31m-  background: #000428;[m
[31m-  padding: 24px;[m
[31m-  border-radius: 12px;[m
[31m-  box-shadow: 0 0 10px rgba(0,0,0,0.3);[m
[31m-  width: 100%;[m
[31m-  max-width: 400px;[m
[31m-}[m
[31m-[m
[31m-.stock-form label {[m
[31m-  font-weight: bold;[m
[31m-  color: var(--branco);[m
[31m-}[m
[31m-[m
[31m-.stock-form input {[m
[31m-  padding: 10px;[m
[31m-  font-size: 1em;[m
[31m-  border: 1px solid var(--cinza-claro);[m
[31m-  border-radius: 8px;[m
[31m-  background-color: #111827;[m
[31m-  color: var(--branco);[m
[31m-}[m
[31m-[m
[31m-.stock-form input::placeholder {[m
[31m-  color: #9ca3af;[m
[31m-}[m
[31m-[m
[31m-.stock-form input:focus {[m
[31m-  border-color: var(--ocre);[m
[31m-}[m
[31m-[m
[31m-.stock-form button {[m
[31m-  background-color: #1abc9c;[m
[31m-  color: var(--branco);[m
[31m-  font-weight: bold;[m
[31m-  padding: 10px;[m
[31m-  border: none;[m
[31m-  border-radius: 8px;[m
[31m-  cursor: pointer;[m
[31m-  transition: background 0.2s ease;[m
[31m-}[m
[31m-[m
[31m-.stock-form button:hover {[m
[31m-  background-color: var(--coral);[m
[31m-}[m
[31m-[m
[31m-.stock-container {[m
[31m-  display: flex;[m
[31m-  gap: 20px;[m
[31m-  flex-wrap: wrap;[m
[31m-  justify-content: center;[m
[31m-  margin-top: 40px;[m
[31m-}[m
[31m-</style>[m
\ No newline at end of file[m
[32m+[m[32m  </style>[m
\ No newline at end of file[m
[1mdiff --git a/src/components/StockCard.vue b/src/components/StockCard.vue[m
[1mindex 364d4b2..c8b3738 100644[m
[1m--- a/src/components/StockCard.vue[m
[1m+++ b/src/components/StockCard.vue[m
[36m@@ -65,7 +65,6 @@[m
               throw new Error (`Erro ao atualizar notificação para ${this.stock.code}`);[m
             }[m
 [m
[31m-            // const action = this.notify ? 'ativada' : 'desativada';[m
           } catch (error) {[m
             alert(`Erro: ${error.message}`);[m
             // Revert toggle state on failure[m
