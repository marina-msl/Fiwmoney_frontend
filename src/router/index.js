import { createRouter, createWebHistory } from 'vue-router';
import LoginView from '@/components/auth/Login.vue';
import RegisterView from '@/components/auth/Register.vue';
import AddView from '@/components/stock/Add.vue';

const routes = [
  { path: '/login', name: 'Login', component: LoginView },
  { path: '/register', name: 'Register', component: RegisterView },
  { path: '/add', name: 'AddStock', component: AddView },
  { path: '/', redirect: '/login' },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
