<script>
export default {
  name: 'App',
  computed: {
    username() {
      return localStorage.getItem('username') || ''
    },
    isAuthenticated() {
      return !!localStorage.getItem('token')
    },
    showHeader() {
      const authRoutes = ['/login', '/register']
      return this.isAuthenticated && !authRoutes.includes(this.$route.path)
    },
    userInitial() {
      return this.username ? this.username.charAt(0).toUpperCase() : ''
    },
  },
  methods: {
    logout() {
      localStorage.removeItem('token')
      localStorage.removeItem('walletId')
      localStorage.removeItem('username')
      this.$router.push('/login')
    },
  },
}
</script>

<template>
  <div class="app-container">
    <header
      v-if="showHeader"
      class="app-header"
    >
      <div class="user-info">
        <div class="user-avatar">
          {{ userInitial }}
        </div>
        <span class="user-name">
          {{ username }}
        </span>
      </div>
      <button
        class="logout-button"
        type="button"
        @click="logout"
      >
        Sair
      </button>
    </header>

    <main
      class="app-main"
      :class="{ 'with-header': showHeader }"
    >
      <router-view />
    </main>
  </div>
</template>

<style>
.app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 20px;
  background: linear-gradient(to right, #000428, #004e92);
  color: #ffffff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 9999px;
  background-color: #1abc9c;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  color: #ffffff;
}

.user-name {
  font-weight: 600;
}

.logout-button {
  padding: 6px 14px;
  border-radius: 9999px;
  border: none;
  background-color: #1abc9c;
  color: #ffffff;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s ease;
}

.logout-button:hover {
  background-color: #16a085;
}

.app-main {
  flex: 1;
}

.app-main.with-header {
  padding-top: 0;
}
</style>
