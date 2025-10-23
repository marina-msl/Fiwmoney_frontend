<template>
  <div class="login-page">
    <form @submit.prevent="login" class="login-form">
      <label for="username">User:</label>
      <input
        id="username"
        type="text"
        v-model="username"
        placeholder="Type your username"
        required
      />

      <label for="password">Password:</label>
      <input
        id="password"
        type="password"
        v-model="password"
        placeholder="Type your password"
        required
      />

      <button type="submit" :disabled="loading">
        {{ loading ? "Logging in..." : "Login" }}
      </button>

       <p class="register-link">
        Don’t have an account?
        <router-link to="/register">Register here</router-link>
      </p>

      <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
    </form>
  </div>
</template>

<script>
export default {
  name: "LoginView",
  data() {
    return {
      username: "",
      password: "",
      loading: false,
      errorMessage: "",
    };
  },
  methods: {
    async login() {
      this.loading = true;
      this.errorMessage = "";

      try {
        const response = await fetch('http://localhost:8080/login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            username: this.username,
            password: this.password
          })
        });

        if (!response.ok) {
          throw new Error('Invalid username or password');
        }

        const data = await response.json();
        localStorage.setItem('token', data.token);

        // Redirecionar o usuário para a tela principal
        // ex: this.$router.push('/dashboard');
      } catch (error) {
        this.errorMessage = error.message;
      } finally {
        this.loading = false;
      }
    }
  },
};
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  background: linear-gradient(to right, #000428, #004e92);
  display: flex;
  justify-content: center;
  align-items: center;
}

.login-form {
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

.login-form label {
  font-weight: bold;
  color: #ffffff;
}

.login-form input {
  padding: 10px;
  font-size: 1em;
  border: 1px solid #ccc;
  border-radius: 8px;
  background-color: #111827;
  color: #fff;
}

.login-form input::placeholder {
  color: #9ca3af;
}

.login-form input:focus {
  border-color: #1abc9c;
  outline: none;
}

.login-form button {
  background-color: #1abc9c;
  color: #fff;
  font-weight: bold;
  padding: 10px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.login-form button:hover {
  background-color: #16a085;
}

.register-link {
  text-align: center;
  color: #ffffff;
  font-size: 0.9em;
}

.register-link a {
  color: #1abc9c;
  text-decoration: none;
  font-weight: bold;
}

.register-link a:hover {
  text-decoration: underline;
}

.error {
  color: #e74c3c;
  text-align: center;
  margin-top: 8px;
}
</style>