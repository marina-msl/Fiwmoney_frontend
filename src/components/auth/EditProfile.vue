<script>
export default {
  name: 'EditProfile',
  emits: ['close'],
  data() {
    return {
      name: localStorage.getItem('name') || '',
      username: localStorage.getItem('username') || '',
      password: '',
      confirmPassword: '',
      loading: false,
      errorMessage: '',
      successMessage: '',
    }
  },
  methods: {
    async save() {
      this.errorMessage = ''
      this.successMessage = ''

      if (this.password && this.password !== this.confirmPassword) {
        this.errorMessage = 'Passwords do not match.'
        return
      }

      this.loading = true

      const token = localStorage.getItem('token')
      const payload = {
        name: this.name,
        username: this.username,
        ...(this.password ? { password: this.password } : {}),
      }

      try {
        // TODO: replace with the actual backend endpoint when available
        const response = await fetch('http://localhost:8080/auth/user', {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`,
          },
          body: JSON.stringify(payload),
        })

        if (!response.ok) {
          let reason = `status ${response.status}`
          try {
            const body = await response.json()
            reason = body.message || body.error || reason
          }
          catch {}
          throw new Error(reason)
        }

        localStorage.setItem('username', this.username)
        if (this.name) localStorage.setItem('name', this.name)
        this.successMessage = 'Profile updated successfully.'
        this.password = ''
        this.confirmPassword = ''
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
  <div class="modal-backdrop" @click.self="$emit('close')">
    <div class="modal">
      <div class="modal-header">
        <h3>Edit Profile</h3>
        <button type="button" class="close-btn" @click="$emit('close')">
          ✕
        </button>
      </div>

      <form class="modal-form" @submit.prevent="save">
        <label>Name</label>
        <input v-model="name" type="text" placeholder="Your name">

        <label>Username</label>
        <input v-model="username" type="text" placeholder="Username" required>

        <label>New Password</label>
        <input v-model="password" type="password" placeholder="Leave blank to keep current">

        <label>Confirm Password</label>
        <input v-model="confirmPassword" type="password" placeholder="Repeat new password">

        <p v-if="errorMessage" class="msg error">
          {{ errorMessage }}
        </p>
        <p v-if="successMessage" class="msg success">
          {{ successMessage }}
        </p>

        <div class="modal-actions">
          <button type="button" class="btn cancel" @click="$emit('close')">
            Cancel
          </button>
          <button type="submit" class="btn save" :disabled="loading">
            {{ loading ? 'Saving...' : 'Save' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 200;
}

.modal {
  background: #1a2235;
  border: 1px solid #30363d;
  border-radius: 14px;
  padding: 24px;
  width: 100%;
  max-width: 380px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.modal-header h3 {
  color: #ffffff;
  margin: 0;
  font-size: 1.1rem;
}

.close-btn {
  background: none;
  border: none;
  color: #9ca3af;
  font-size: 1rem;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 6px;
  transition: color 0.2s;
}

.close-btn:hover {
  color: #ffffff;
}

.modal-form {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.modal-form label {
  color: #9ca3af;
  font-size: 0.85rem;
  font-weight: 600;
  margin-bottom: -6px;
}

.modal-form input {
  padding: 10px;
  border-radius: 8px;
  border: 1px solid #30363d;
  background-color: #111827;
  color: #ffffff;
  font-size: 0.95rem;
}

.modal-form input:focus {
  border-color: #1abc9c;
  outline: none;
}

.modal-form input::placeholder {
  color: #4b5563;
}

.msg {
  margin: 0;
  font-size: 0.85rem;
  text-align: center;
}

.error {
  color: #e74c3c;
}

.success {
  color: #1abc9c;
}

.modal-actions {
  display: flex;
  gap: 10px;
  margin-top: 6px;
}

.btn {
  flex: 1;
  padding: 10px;
  border-radius: 8px;
  border: none;
  font-weight: 600;
  font-size: 0.95rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.btn.save {
  background-color: #1abc9c;
  color: #ffffff;
}

.btn.save:hover:not(:disabled) {
  background-color: #16a085;
}

.btn.save:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn.cancel {
  background-color: #374151;
  color: #ffffff;
}

.btn.cancel:hover {
  background-color: #4b5563;
}
</style>
