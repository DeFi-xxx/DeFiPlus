<template>
  <div>
    <div class="container">
      <div>
        <span>tokenA: </span><button @click="approveToken(tokenA)">授权</button>
        <input v-model="tokenA"/>
      </div>
      <div>
        <span>tokenB: </span><button @click="approveToken(tokenB)">授权</button>
        <input v-model="tokenB"/>
      </div>
      <div><span>tokenA数量: </span><input v-model="tokenANum"/></div>
      <div><span>tokenB数量: </span><input v-model="tokenBNum"/></div>
      <div><span>LP持有人: </span><input v-model="address"/></div>
      <div><span>失效时间: </span><input v-model="time"/></div>
      <button @click="submit">提供流动性</button>
    </div>
  </div>
</template>

<script>
const IMdexRouter = require('@/abi/IMdexRouter.json')
const IMdexPair = require('@/abi/IMdexPair.json')
const max = '0x' + 'f'.repeat(64)
export default {
  name: 'Lp',
  data () {
    return {
      tokenA: '0x4E5a3E59D33b792B3C51193a9631D557a6B43619', //test
      tokenB: '',
      tokenANum: 1e18,
      tokenBNum: 1e18,
      address: '',
      time: parseInt(Date.now() / 1000 + 3600),
      web3: null,
      web3Provider: null,
      contracts: {},
      account: null,
      authed: true
    }
  },
  mounted: function(){
    this.initWeb3()
  },
  computed: {
  },
  methods: {
    initWeb3: async function () {
      if (window.ethereum) {
        window.web3 = new window.Web3(window.ethereum)
        try {
          await window.ethereum.enable()
          // await window.ethereum.send('eth_requestAccounts')
          this.web3Provider = window.ethereum
        } catch (error) {}
      } else if (window.web3) {
        this.web3Provider = window.web3.currentProvider
        window.web3 = new window.Web3(window.web3.currentProvider)
      } else {
        console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
        window.web3 = new window.Web3(new window.Web3.providers.HttpProvider('https://http-mainnet-node.huobichain.com'))
        this.web3Provider = window.web3.currentProvider
        this.authed = false
      }
      if (this.authed) this.checkAccount()
      return this.initContract()
    },
    initContract: async function () {
      this.contracts.IMdexRouter = window.TruffleContract(IMdexRouter)
      this.contracts.IMdexRouter.setProvider(this.web3Provider)
      this.contracts.IMdexPair = window.TruffleContract(IMdexPair)
      this.contracts.IMdexPair.setProvider(this.web3Provider)
      this.contracts.IMdexRouterIns = await this.contracts.IMdexRouter.deployed()
      window.contracts = this.contracts
    },
    approveToken: function(token){
      this.contracts.IMdexPair.at(token).then(ins=>{
        ins.approve(this.contracts.IMdexRouter.address, max).then(console.log,console.log)
      })
    },
    submit: function(){
      this.contracts.IMdexRouterIns.addLiquidity(this.tokenA,this.tokenB,this.tokenANum,this.tokenBNum,
        this.tokenANum,this.tokenBNum,this.address,this.time).then(console.log,console.log)
    },
    checkAccount: function () {
      this.address = window.web3.eth.defaultAccount = this.account = window.web3.eth.coinbase
      setInterval(() => {
        if (this.account !== window.web3.eth.coinbase) {
          this.address = window.web3.eth.defaultAccount = this.account = window.web3.eth.coinbase
          this.initContract()
        }
      }, 3000)
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  .container{
    max-width: 600px;
    background: rgb(51, 55, 74);
    padding: 20px 10px;
    line-height: 35px;
  }
  .container input{
    width: 350px;
    margin-right: 20px;
  }
  .container span{
    display: inline-block;
    width: 80px;
  }
  .container div button{
    float: right;
  }
</style>
