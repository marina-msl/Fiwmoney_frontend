<script>
export default {
  name: 'UserAvatar',
  props: {
    username: {
      type: String,
      default: '',
    },
  },
  emits: ['edit-profile'],
  data() {
    return {
      userPhoto: localStorage.getItem('userPhoto') || null,
      menuOpen: false,
    }
  },
  computed: {
    userInitial() {
      return this.username ? this.username.charAt(0).toUpperCase() : ''
    },
  },
  methods: {
    toggleMenu() {
      this.menuOpen = !this.menuOpen
    },
    closeMenu() {
      this.menuOpen = false
    },
    openPhotoPicker() {
      this.menuOpen = false
      this.$refs.photoInput.click()
    },
    removePhoto() {
      this.userPhoto = null
      localStorage.removeItem('userPhoto')
      this.menuOpen = false
    },
    onPhotoSelected(event) {
      const file = event.target.files[0]
      if (!file) return
      const reader = new FileReader()
      reader.onload = (e) => {
        this.userPhoto = e.target.result
        localStorage.setItem('userPhoto', e.target.result)
      }
      reader.readAsDataURL(file)
    },
    openEditProfile() {
      this.menuOpen = false
      this.$emit('edit-profile')
    },
  },
}
</script>

<template>
  <div class="avatar-wrapper">
    <div class="user-avatar" @click="toggleMenu">
      <img v-if="userPhoto" :src="userPhoto" class="user-avatar-img" alt="User photo">
      <span v-else>{{ userInitial }}</span>
    </div>

    <div v-if="menuOpen" class="avatar-menu">
      <div class="avatar-menu-photo">
        <img v-if="userPhoto" :src="userPhoto" class="avatar-menu-img" alt="User photo">
        <div v-else class="avatar-menu-initial">
          {{ userInitial }}
        </div>
      </div>
      <span class="avatar-menu-username">{{ username }}</span>
      <button type="button" class="avatar-menu-btn" @click="openPhotoPicker">
        Change photo
      </button>
      <button v-if="userPhoto" type="button" class="avatar-menu-btn remove" @click="removePhoto">
        Remove photo
      </button>
      <button type="button" class="avatar-menu-btn" @click="openEditProfile">
        Edit profile
      </button>
    </div>

    <div v-if="menuOpen" class="avatar-menu-backdrop" @click="closeMenu" />

    <input
      ref="photoInput"
      type="file"
      accept="image/*"
      style="display: none"
      @change="onPhotoSelected"
    >
  </div>
</template>

<style scoped>
.avatar-wrapper {
  position: relative;
}

.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 9999px;
  background-color: #1abc9c;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  color: #ffffff;
  cursor: pointer;
  overflow: hidden;
  transition: opacity 0.2s ease;
}

.user-avatar:hover {
  opacity: 0.85;
}

.user-avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 9999px;
}

.avatar-menu {
  position: absolute;
  top: 48px;
  left: 0;
  background: #1a2235;
  border: 1px solid #30363d;
  border-radius: 12px;
  padding: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  z-index: 100;
  min-width: 160px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
}

.avatar-menu-photo {
  width: 72px;
  height: 72px;
  border-radius: 9999px;
  overflow: hidden;
  background-color: #1abc9c;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar-menu-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-menu-initial {
  font-size: 28px;
  font-weight: 700;
  color: #ffffff;
}

.avatar-menu-username {
  font-weight: 600;
  color: #ffffff;
  font-size: 0.95rem;
}

.avatar-menu-btn {
  width: 100%;
  padding: 6px 12px;
  border-radius: 8px;
  border: none;
  background-color: #1abc9c;
  color: #ffffff;
  font-weight: 600;
  font-size: 0.85rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.avatar-menu-btn:hover {
  background-color: #16a085;
}

.avatar-menu-btn.remove {
  background-color: #e74c3c;
}

.avatar-menu-btn.remove:hover {
  background-color: #c0392b;
}

.avatar-menu-backdrop {
  position: fixed;
  inset: 0;
  z-index: 99;
}
</style>
