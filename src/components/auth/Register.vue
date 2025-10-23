<template>
  <div class="register-page">
    <form @submit.prevent="register" class="register-form">
      <label for="name">Full Name:</label>
      <input
        id="name"
        type="text"
        v-model="name"
        placeholder="Type your full name"
        required
      />

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

      <label for="confirmPassword">Confirm Password:</label>
      <input
        id="confirmPassword"
        type="password"
        v-model="confirmPassword"
        placeholder="Confirm your password"
        required
      />

      <label for="tenant">Tenant:</label>
      <input
        id="tenant"
        type="text"
        v-model="tenant"
        placeholder="Enter tenant ID"
        required
      />

      <button type="submit" :disabled="loading">
        {{ loading ? "Registering..." : "Register" }}
      </button>

      <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
    </form>
  </div>
</template>

<script>
export default {
  name: "RegisterView",
  data() {
    return {
      name: "",
      username: "",
      password: "",
      confirmPassword: "",
      tenant: "",
      loading: false,
      errorMessage: "",
    };
  },
  methods: {
    async register() {
      if (this.password !== this.confirmPassword) {
        this.errorMessage = "Passwords do not match";
        return;
      }

      this.loading = true;
      this.errorMessage = "";

      try {
        const response = await fetch("http://localhost:8080/register", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            name: this.name,
            username: this.username,
            password: this.password,
            tenant: this.tenant
          }),
        });

        if (!response.ok) {
          throw new Error("Registration failed");
        }

        const data = await response.json();
        // opcional: armazenar token ou redirecionar
        localStorage.setItem("token", data.token);
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
