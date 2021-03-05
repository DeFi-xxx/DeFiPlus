import Vue from 'vue'
import Router from 'vue-router'
import Index from '@/components/Index'
import Lp from '@/components/Lp'
import Index1 from '@/components/Index1'
import Home from '@/view/home'
import Airdrop from '@/view/airdrop';
import AirdropProjecter from '@/view/airdropProjecter'
import Dig from '@/view/dig'
import DigProjecter from '@/view/digProjecter'



Vue.use(Router)

export default new Router({
  base: location.pathname.replace(/(.*)(\/.*)/, '$1'),
  mode: 'history',
  routes: [
    // {
    //   path: '/',
    //   name: 'Index',
    //   component: Index
    // },
    {
      path: '/Lp',
      name: 'Lp',
      component: Lp
    },
    {
      path: '/index1',//首页
      name: 'Index1',
      component: Index1
    },
    {
      path: '/',//首页
      name: 'home',
      component: Home
    },
    {
      path: '/airdrop',//空投
      name: 'airdrop',
      component: Airdrop
    },
    {
      path: '/airdropProjecter',//空投
      name: 'airdropProjecter',
      component: AirdropProjecter
    },
    {
      path: '/dig',//挖矿
      name: 'dig',
      component:Dig
    },
    {
      path: '/digProjecter',//挖矿
      name: 'digProjecter',
      component:DigProjecter
    }
  ]
})
