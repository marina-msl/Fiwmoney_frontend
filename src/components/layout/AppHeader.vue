<script>
import UserAvatar from '@/components/layout/UserAvatar.vue'

export default {
  name: 'AppHeader',
  components: { UserAvatar },
  props: {
    username: {
      type: String,
      default: '',
    },
  },
  emits: ['edit-profile'],
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
  <header class="app-header">
    <div class="user-info">
      <UserAvatar :username="username" @edit-profile="$emit('edit-profile')" />
      <span class="user-name">{{ username }}</span>
    </div>
    <button class="logout-button" type="button" @click="logout">
      Sair
    </button>
  </header>
</template>

<style scoped>
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

.user-name {
  font-weight: 600;
  color: #ffffff;
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
</style>
