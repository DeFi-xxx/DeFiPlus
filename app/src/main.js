import Vue from 'vue'
import App from './App.vue'
import router from './router'

Vue.config.productionTip = false
Vue.filter('numFilter', function (value) {
  return isNaN(value) ? '--' : Number((parseInt(value * 10 ** 4) / 10 ** 4).toFixed(4))
})
Vue.directive('timer', {
  bind(el, binding) {
    el.__time = binding.value;
    el.__timer = setInterval(() => {
      let f = v => (v < 10 ? '0' + v : v),
        o = el.__time - Date.now() / 1000;
      let d = Math.floor(o / 86400),
        h = Math.floor(o % 86400 / 3600),
        m = Math.floor(o % 3600 / 60),
        s = Math.floor(o % 60);

      el.innerHTML = o > 0 ? `<span>${f(h)}</span>:<span>${f(m)}</span>:<span>${f(s)}</span>`
        : '<span>00</span>:<span>00</span>:<span>00</span>';
    }, 1000);
  },
  update(el, binding) {
    el.__time = binding.value;
  },
  unbind(el, binding) {
    clearInterval(el.__timer);
  }
});

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')
