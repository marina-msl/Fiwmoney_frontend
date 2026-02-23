<script>
export default {
  name: 'RegisterView',
  data() {
    return {
      name: '',
      username: '',
      email: '',
      password: '',
      confirmPassword: '',
      loading: false,
      errorMessage: '',
    }
  },
  methods: {
    async register() {
      if (this.password !== this.confirmPassword) {
        this.errorMessage = 'Passwords do not match'
        return
      }

      this.loading = true
      this.errorMessage = ''

      try {
        const response = await fetch('http://localhost:8080/auth/register', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            name: this.name,
            email: this.email,
            username: this.username,
            password: this.password,
          }),
        })

        if (!response.ok) {
          throw new Error('Registration failed')
        }

        const data = await response.json()
        localStorage.setItem('token', data.token)
        localStorage.setItem('walletId', data.walletId)
        localStorage.setItem('username', this.username)

        this.successMessage = 'User registered successfully!'
        setTimeout(() => {
          this.$router.push('/add')
        }, 1500)
      }
      catch (error) {
        this.errorMessage = error.message
      }
      finally {
        this.loading = false
      }
    },
  },
}
</script>

<template>
  <div class="register-page">
    <form class="register-form" @submit.prevent="register">
      <label for="name">Full Name:</label>
      <input
        id="name"
        v-model="name"
        type="text"
        placeholder="Type your full name"
        required
      >

      <label for="email">E-mail:</label>
      <input
        id="email"
        v-model="email"
        type="text"
        placeholder="Type your e-mail"
        required
      >

      <label for="username">User:</label>
      <input
        id="username"
        v-model="username"
        type="text"
        placeholder="Type your username"
        required
      >

      <label for="password">Password:</label>
      <input
        id="password"
        v-model="password"
        type="password"
        placeholder="Type your password"
        required
      >

      <label for="confirmPassword">Confirm Password:</label>
      <input
        id="confirmPassword"
        v-model="confirmPassword"
        type="password"
        placeholder="Confirm your password"
        required
      >

      <button type="submit" :disabled="loading">
        {{ loading ? "Registering..." : "Register" }}
      </button>

      <p v-if="errorMessage" class="error">
        {{ errorMessage }}
      </p>
    </form>
  </div>
</template>

<style scoped>
.register-page {
  min-height: 100vh;
  background: linear-gradient(to right, #000428, #004e92);
  display: flex;
  justify-content: center;
  align-items: center;
}

.register-form {
  background-color: #000428;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
  width: 100%;
  max-width: 400px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.register-form label {
  font-weight: bold;
  color: #ffffff;
}

.register-form input {
  padding: 10px;
  font-size: 1em;
  border: 1px solid #ccc;
  border-radius: 8px;
  background-color: #111827;
  color: #fff;
}

.register-form input::placeholder {
  color: #9ca3af;
}

.register-form input:focus {
  border-color: #1abc9c;
  outline: none;
}

.register-form button {
  background-color: #1abc9c;
  color: #fff;
  font-weight: bold;
  padding: 10px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.register-form button:hover {
  background-color: #16a085;
}

.error {
  color: #e74c3c;
  text-align: center;
  margin-top: 8px;
}
</style>
