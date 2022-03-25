import { createApp } from 'vue'
import App from './timer.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#timer-0225';

  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
