<script>
import EditProfile from '@/components/auth/EditProfile.vue'
import AppHeader from '@/components/layout/AppHeader.vue'

export default {
  name: 'App',
  components: { AppHeader, EditProfile },
  data() {
    return {
      username: localStorage.getItem('username') || '',
      isAuthenticated: !!localStorage.getItem('token'),
      editProfileOpen: false,
    }
  },
  computed: {
    showHeader() {
      const authRoutes = ['/login', '/register']
      return this.isAuthenticated && !authRoutes.includes(this.$route.path)
    },
  },
  watch: {
    $route() {
      this.username = localStorage.getItem('username') || ''
      this.isAuthenticated = !!localStorage.getItem('token')
    },
  },
}
</script>

<template>
  <div class="app-container">
    <AppHeader
      v-if="showHeader"
      :username="username"
      @edit-profile="editProfileOpen = true"
    />

    <main class="app-main" :class="{ 'with-header': showHeader }">
      <router-view />
    </main>

    <EditProfile v-if="editProfileOpen" @close="editProfileOpen = false" />
  </div>
</template>

<style>
.app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app-main {
  flex: 1;
}

.app-main.with-header {
  padding-top: 0;
}
</style>
