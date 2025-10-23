import { createRouter, createWebHistory } from 'vue-router';

import LoginView from '@/components/auth/Login.vue';
import RegisterView from '@/components/auth/Register.vue';

const routes = [
  { path: '/login', name: 'Login', component: LoginView },
  { path: '/register', name: 'Register', component: RegisterView },
  { path: '/', redirect: '/login' },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
