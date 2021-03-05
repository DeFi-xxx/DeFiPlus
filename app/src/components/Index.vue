<template>
  <div>
    <div class="container">
      <div class="head"><img src="img/logo.png"/></div>
      <div class="slogan"><img src="img/slogan.png"/></div>
      <div class="box1">
        <span>
          <span>HTAlpha当前流通量</span>
          <a :href="getContractUrl('HTAlpha')" target="_blank"><img src="img/validate.png"/></a>
        </span>
        <span>{{HTATotal | numFilter}} HTA</span>
      </div>
      <div class="flex">
        <div class="box2">
          <div class="title center">HT</div>
          <div class="line"></div>
          <div><span>已抵押</span><span class="color1">{{HTMortgage | numFilter}} HT</span></div>
          <div><span>余额</span><span>{{HTBalance | numFilter}} HT</span></div>
          <div>
            <button class="button2" @click="showWithdrawBox(false, 'HT')">抵押</button>
            <button class="button1" @click="showWithdrawBox(true, 'HT')">提现</button>
          </div>
        </div>
        <div class="box2">
          <div class="title">HTAlpha <a :href="getSwapUrl('HTAlpha')" target="_blank">交易</a></div>
          <div class="line"></div>
          <div><span>可结算</span><span class="color2">{{HTASettleable | numFilter}} HTA</span></div>
          <div><span>余额</span><span>{{HTABalance | numFilter}} HTA</span></div>
          <div>
            <div class="timer1"><b v-timer="HTATime"><span>00</span>:<span>00</span>:<span>00</span></b></div>
            <button v-if="canSettleA" class="button1" @click="settlementAlpha">结算</button>
            <button v-else class="button4">结算</button>
          </div>
        </div>
      </div>
      <div class="box1">
        <span>
          <span>HTBeta当前流通量</span>
          <a :href="getContractUrl('HTBeta')" target="_blank"><img src="img/validate.png"/></a>
        </span>
        <span>{{HTBTotal | numFilter}} HTB</span>
      </div>
      <div class="box3">
        <div class="box_power">全网算力 {{power | numFilter}} G</div>
        <div><span>矿池余额 &nbsp;&nbsp;&nbsp;&nbsp; {{pool | numFilter}} HTB + </span><span>{{calcOutput | numFilter}} HTB</span></div>
        <div class="timer2"><b v-timer="HTBTime"><span>00</span>:<span>00</span>:<span>00</span></b></div>
      </div>
      <div class="flex">
        <div class="box2">
          <div class="title">HTA-HT-LP <a :href="getAddLPUrl('HTAlpha')" target="_blank">流动性</a></div>
          <div class="line"></div>
          <div><span>已抵押</span><span class="color3">{{HTALPMortgage | numFilter}} HTALP</span></div>
          <div><span>余额</span><span>{{HTALPBalance | numFilter}} HTALP</span></div>
          <div>&nbsp;</div>
          <div>
            <button v-if="!HTALPApprove" class="button2" @click="approveHTALP">授权</button>
            <button v-else class="button2" @click="showWithdrawBox(false, 'HTALP')">抵押</button>
            <button class="button1" @click="showWithdrawBox(true, 'HTALP')">提现</button>
          </div>
        </div>
        <div class="box2">
          <div class="title">HTBeta <a :href="getSwapUrl('HTBeta')" target="_blank">交易</a></div>
          <div class="line"></div>
          <div><span>算力</span>
            <span class="color2 calc">{{myPower | numFilter}}G
              <b class="multiple"> X{{multiple}}</b>
            </span>
          </div>
          <div><span>可结算</span><span class="color2">{{HTBSettleable | numFilter}} HTB</span></div>
          <div><span>余额</span><span>{{HTBBalance | numFilter}} HTB</span></div>
          <div>
            <span class="advance">快{{advanceTime}}分钟</span>
            <button v-if="canSettleB" class="button1" @click="settlementBeta">结算</button>
            <button v-else class="button4">结算</button>
          </div>
        </div>
      </div>
      <div class="box1">
        <span>
          <span>HTCube当前流通量</span>
          <a :href="getContractUrl('HTCube')" target="_blank"><img src="img/validate.png"/></a>
        </span>
        <span>{{HTCTotal | numFilter}} HTC</span>
      </div>
      <div class="flex">
        <div class="box2">
          <div class="title">HTB-HT-LP <a :href="getAddLPUrl('HTBeta')" target="_blank">流动性</a></div>
          <div class="line"></div>
          <div><span>已抵押</span><span class="color3">{{HTBLPMortgage | numFilter}} HTBLP</span></div>
          <div><span>余额</span><span>{{HTBLPBalance | numFilter}} HTBLP</span></div>
          <div>
            <button v-if="!HTBLPApprove" class="button2" @click="approveHTBLP">授权</button>
            <button v-else class="button2" @click="showWithdrawBox(false, 'HTBLP')">抵押</button>
            <button class="button1" @click="showWithdrawBox(true, 'HTBLP')">提现</button>
          </div>
        </div>
        <div class="box2">
          <div class="title">HTCube <a :href="getSwapUrl('HTCube')" target="_blank">交易</a></div>
          <div class="line"></div>
          <div><span>可结算</span><span class="color2">{{HTCSettleable | numFilter}} HTC</span></div>
          <div><span>余额</span><span>{{HTCBalance | numFilter}} HTC</span></div>
          <div>
            <button class="button2" @click="showUseBox">使用</button>
            <button  v-if="canSettleC" class="button1" @click="settlementCube">结算</button>
            <div v-else class="timer1"><b v-timer="HTCTime"><span>00</span>:<span>00</span>:<span>00</span></b></div>
          </div>
        </div>
      </div>
      <div class="box4">
        <div>邀请统计</div>
        <div class="line"></div>
        <div>
          <span>邀请链接</span>
          <span v-if="!HTATime">未注册</span>
          <span v-else @click="copy" class="btn" :data-clipboard-text="getLink()">复制</span>
        </div>
        <div><span>邀请人数</span><span>{{number}}</span></div>
        <div><span>邀请收益</span><span>{{revenue | numFilter}} HTA</span></div>
      </div>
    </div>
    <div v-show="showMask" class="mui-popup-backdrop" @click="closePop"></div>
    <div v-show="showSend" class="mui-popup mui-popup-in">
    <div class="mui-popup-inner">
      <div class="mui-popup-text">
        <div v-if="sendFlag" class="send">
          <img src="img/success.png" />
          <div>操作成功</div>
        </div>
        <div v-else class="send fail">
          <img src="img/fail.png" />
          <div>{{err || '操作失败'}}</div>
        </div>
      </div>
    </div>
  </div>
    <div v-show="showWithdraw" class="mui-popup">
      <div class="mui-popup-inner">
        <div class="mui-popup-title">
          {{isWithdraw?'提现':'抵押'}}
          <div class="line"></div>
          <img @click="closePop" src="img/close.png">
        </div>
        <div class="mui-popup-text">
          <div class="flex"><span>{{isWithdraw?'已抵押':'余额'}}:</span><span>{{currencyValue | numFilter}} {{currency}}</span></div>
          <div class="input_box">
            <input type="number" :placeholder="isWithdraw?'提现数量':'抵押数量'" v-model.number="withdrawNumber" />
            <span @click="maxWithdraw">MAX</span>
          </div>
          <div class="sub_btn">
            <button class="button3" @click="closePop">取消</button>
            <button class="button2" @click="submit">提交</button>
          </div>
        </div>
      </div>
    </div>
    <div v-show="showUse" class="mui-popup">
      <div class="mui-popup-inner">
        <div class="mui-popup-title">
          使用
          <div class="line"></div>
          <img @click="closePop" src="img/close.png">
        </div>
        <div class="mui-popup-text">
          <div class="flex"><span>余额:</span><span>{{HTCBalance | numFilter}} HTC</span></div>
          <div class="use_box">
            <div :class="option?'active':''" @click="option=1">
              <span>消耗{{advanceTimeCube}}HTC</span>
              <span>加速{{advanceTime+1}}分钟</span>
              <img v-if="option" src="img/select.png"/>
              <b v-else>&nbsp;</b>
            </div>
            <div :class="option?'':'active'" @click="option=0">
              <span>消耗{{multipleCube}}HTC</span>
              <span>基础算力x{{multiple*2}}</span>
              <img v-if="!option" src="img/select.png"/>
              <b v-else>&nbsp;</b>
            </div>
          </div>
          <div class="sub_btn">
            <button class="button3" @click="closePop">取消</button>
            <button class="button2" @click="boostBeta">确认</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
const HTAlpha = require('@/abi/HTAlpha.json')
const HTBeta = require('@/abi/HTBeta.json')
const HTCube = require('@/abi/HTCube.json')
const IMdexFactory = require('@/abi/IMdexFactory.json')
const IMdexPair = require('@/abi/IMdexPair.json')
const max = '0x' + 'f'.repeat(64)
const sixHour = 21600
export default {
  name: 'Index',
  data () {
    return {
      wrappedHT: {
        '128': '0x5545153ccfca01fbd7dd11c0b23ba694d9509a6f', //main
        '256': '', //test
      },
      addrs: {
        'HTAlpha': '0x6Aa4DAcA9730B45813138175c3f3F4925D6C3999',
        'HTBeta': '0xb0C635B3Fd23296E84dA938F36fb38b68e6962Da',
        'HTCube': '0x3cf47A148324410e3bACa41F522049b189c77CCf'
      },
      HTBLPAddress: '',
      HTATotal: 0,
      HTBTotal: 0,
      HTCTotal: 0,
      HTATime: 0,
      HTBTime: 0,
      HTCTime: 0,
      HTBalance: 0,
      HTABalance: 0,
      HTBBalance: 0,
      HTCBalance: 0,
      HTMortgage: 0,
      HTALPMortgage: 0,
      HTBLPMortgage: 0,
      HTALPBalance: 0,
      HTBLPBalance: 0,
      HTALPApprove: 0,
      HTBLPApprove: 0,
      HTASettleable: 0,
      HTCSettleable: 0,
      power: 0,
      pool: 0,
      output: 0,
      yield: 0,
      lastTime: 0,
      myLastTime: 0,
      myPower: 0,
      multiple: 0,
      advanceTime: 0,
      multipleCube: 0,
      advanceTimeCube: 0,
      isWithdraw: false,
      currency: 'HT',
      currencyValue: 0,
      showMask: false,
      showWithdraw: false,
      showUse: false,
      showSend: false,
      sendFlag: false,
      err: '',
      option: 0,
      withdrawNumber: '',
      web3: null,
      web3Provider: null,
      contracts: {},
      superiorID: '0x0',
      revenue: 0,
      number: 0,
      account: null,
      authed: true,
      now: 0
    }
  },
  mounted: function(){
    setInterval(() => {this.now = Date.now() / 1000}, 1000)
    this.initSuperiorID()
    this.initWeb3()
  },
  computed: {
    HTBSettleable: function(){
      if(this.power<=0) return 0
      let output = this.calcOutput
      let calc = this.myPower * this.multiple / this.power * this.yield * 2
      let pool = output + this.pool
      if(this.now < this.HTBTime - this.advanceTime * 60) pool = this.pool
      // else if(this.now < this.HTBTime && calc <= output) pool = output
      return Math.min(pool, calc) * 0.99
    },
    calcOutput: function(){
      let advanceTime = this.advanceTime * 60
      let ratio = (this.HTBTime-this.now-advanceTime)/(21600-advanceTime)
      let output = Math.max(1-Math.max(ratio,0),0)*this.output
      if(this.HTBTime && this.now > this.HTBTime + sixHour - advanceTime) output += this.yield
      return output
    },
    canSettleA: function(){
      return this.now >= this.HTATime
    },
    canSettleB: function(){
      let advanceTime = this.advanceTime * 60
      return (this.myLastTime < this.lastTime - advanceTime)
        || (this.now >= this.HTBTime - advanceTime && this.myLastTime < this.HTBTime - advanceTime)
        || (this.now >= this.HTBTime + sixHour - advanceTime)
    },
    canSettleC: function(){
      return this.now >= this.HTCTime
    }
  },
  methods: {
    closePop: function(){
      this.showMask = false
      this.showWithdraw = false
      this.showUse = false
    },
    showWithdrawBox: function (isWithdraw, currency) {
      this.withdrawNumber = ''
      this.isWithdraw = isWithdraw
      this.currency = currency
      let suffix = isWithdraw ? 'Mortgage' : 'Balance'
      this.currencyValue = this[currency + suffix]
      this.showMask = true
      this.showWithdraw = true
    },
    maxWithdraw: function (){
      let currencyValue = this.currencyValue
      if(this.currency=='HT' && !this.isWithdraw) currencyValue -= 0.01
      this.withdrawNumber = Number((parseInt(currencyValue * 10 ** 4) / 10 ** 4).toFixed(4))
    },
    showUseBox: function () {
      this.showMask = true
      this.showUse = true
    },
    showSendBox: function (flag, err) {
      this.showSend = true
      this.sendFlag = flag
      this.err = err
      setTimeout(() => {
        this.showSend = false
      }, 3000)
    },
    initWeb3: async function () {
      if (window.ethereum) {
        window.web3 = new window.Web3(window.ethereum)
        try {
          await window.ethereum.enable()
          // await window.ethereum.send('eth_requestAccounts')
          // await window.ethereum.sendAsync({method:'eth_requestAccounts',params:[]}, console.log)
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
      this.contracts.HTAlpha = window.TruffleContract(HTAlpha)
      this.contracts.HTAlpha.setProvider(this.web3Provider)
      this.contracts.HTBeta = window.TruffleContract(HTBeta)
      this.contracts.HTBeta.setProvider(this.web3Provider)
      this.contracts.HTCube = window.TruffleContract(HTCube)
      this.contracts.HTCube.setProvider(this.web3Provider)
      this.contracts.IMdexFactory = window.TruffleContract(IMdexFactory)
      this.contracts.IMdexFactory.setProvider(this.web3Provider)
      this.contracts.IMdexPair = window.TruffleContract(IMdexPair)
      this.contracts.IMdexPair.setProvider(this.web3Provider)
      this.contracts.HTAlphaIns = await this.contracts.HTAlpha.deployed()
      this.contracts.HTBetaIns = await this.contracts.HTBeta.deployed()
      this.contracts.HTCubeIns = await this.contracts.HTCube.deployed()
      this.contracts.IMdexFactoryIns = await this.contracts.IMdexFactory.deployed()
      let wrappedHT = this.wrappedHT[this.contracts.IMdexFactory.network_id]
      let HTALPAddress = await this.contracts.IMdexFactoryIns.pairFor(wrappedHT,this.contracts.HTAlpha.address)
      let HTBLPAddress = await this.contracts.IMdexFactoryIns.pairFor(wrappedHT,this.contracts.HTBeta.address)
      this.contracts.HTALPIns = this.contracts.IMdexPair.at(HTALPAddress)
      let totalHTBLP = await this.contracts.IMdexPair.at(HTBLPAddress).totalSupply()
      this.contracts.HTBLPIns = this.contracts.IMdexPair.at(HTBLPAddress)
      if(totalHTBLP>0){
        this.HTBLPAddress = HTBLPAddress
      }
      this.initData()
      window.contracts = this.contracts
    },
    initData: function () {
      this.getBalance()
      clearInterval(window.interval)
      window.interval = setInterval(() => {
        this.getBalance()
      }, 20000)
    },
    getBalance: function () {
      //总量
      this.contracts.HTAlphaIns.totalSupply().then(res => {
        this.HTATotal = res / 10 ** 18
      }).catch(console.log)
      this.contracts.HTBetaIns.totalSupply().then(res => {
        this.HTBTotal = res / 10 ** 18
      }).catch(console.log)
      this.contracts.HTCubeIns.totalSupply().then(res => {
        this.HTCTotal = res / 10 ** 18
      }).catch(console.log)
      this.contracts.HTBetaIns.mineInfo().then(res => {
        this.lastTime = parseInt(res[0])
        this.HTBTime = parseInt(res[1]) //本轮结束时间
        this.pool = res[2] / 10 ** 18
        this.output = res[3] / 10 ** 18
        this.power = res[4] / 10 ** 18
      }).catch(console.log)
      this.contracts.HTBetaIns.yield().then(res => {
        this.yield = res / 10 ** 18
      })
      if(!this.account) return
      //余额
      window.web3.eth.getBalance(this.account, (err, res) => {
        if (!err) this.HTBalance = res / 10 ** 18
        else console.log(err)
      })
      this.contracts.HTAlphaIns.balanceOf(this.account).then(res => {
        this.HTABalance = res / 10 ** 18
      }).catch(console.log)
      this.contracts.HTBetaIns.balanceOf(this.account).then(res => {
        this.HTBBalance = res / 10 ** 18
      }).catch(console.log)
      this.contracts.HTCubeIns.balanceOf(this.account).then(res => {
        this.HTCBalance = res / 10 ** 18
      }).catch(console.log)
      // 抵押信息
      this.contracts.HTAlphaIns.mortgageInfoMap(this.account).then(res => {
        this.HTATime = parseInt(res[0])
        this.HTMortgage = res[1] / 10 ** 18
        this.contracts.HTAlphaIns.calcToken(parseInt(res[1])).then(res => {
          this.HTASettleable = res / 10 ** 18
        }).catch(console.log)
        this.revenue = res[2] / 10 ** 18
        this.number = parseInt(res[3])
        // if(res[4] != '0x'+'0'.repeat(40)) this.superiorID = res[4]
      }).catch(console.log)
      this.contracts.HTBetaIns.mortgageInfoMap(this.account).then(res => {
        this.myLastTime = parseInt(res[0])
        this.HTALPMortgage = res[1] / 10 ** 18
        this.myPower = res[2] / 10 ** 18
        this.multiple = parseInt(res[3]) || 1
        this.advanceTime = res[4] / 60
        this.multipleCube = res[5] / 10 ** 18 * 2 || 100
        this.advanceTimeCube = res[6] / 10 ** 18 * 2 || 100
      }).catch(console.log)
      this.contracts.HTCubeIns.mortgageInfoMap(this.account).then(res => {
        this.HTCTime = res[0]
        this.HTCSettleable = this.HTBLPMortgage = res[1] / 10 ** 18
      }).catch(console.log)

      this.contracts.HTALPIns.allowance(this.account, this.contracts.HTBeta.address).then(res => {
        this.HTALPApprove = res / 10 ** 18
      }).catch(console.log)
      this.contracts.HTALPIns.balanceOf(this.account).then(res => {
        this.HTALPBalance = res / 10 ** 18
      }).catch(console.log)
      this.contracts.HTBLPIns.allowance(this.account, this.contracts.HTCube.address).then(res => {
        this.HTBLPApprove = res / 10 ** 18
      }).catch(console.log)
      this.contracts.HTBLPIns.balanceOf(this.account).then(res => {
        this.HTBLPBalance = res / 10 ** 18
      }).catch(console.log)
    },
    success: function(){
      this.showSendBox(true)
      setTimeout(() => {
        this.getBalance()
      }, 5000)
    },
    fail: function(err){
      this.showSendBox(false)
      console.log(err)
    },
    mortgageHT: function(){
      if(this.withdrawNumber>this.HTBalance) return this.showSendBox(false, '余额不足')
      this.contracts.HTAlphaIns.mortgageHT(this.superiorID, {
        from: this.account,
        value: this.withdrawNumber * 10 ** 18
      }).then(this.success, this.fail)
    },
    withdrawHT: function(){
      if(this.withdrawNumber>this.HTMortgage) return this.showSendBox(false, '可提现余额不足')
      this.contracts.HTAlphaIns.withdrawHT(this.withdrawNumber * 10 ** 18).then(this.success, this.fail)
    },
    settlementAlpha: function(){
      if(this.HTASettleable<=0) return this.showSendBox(false, '可结算余额不足')
      this.contracts.HTAlphaIns.settlementAlpha().then(this.success, this.fail)
    },
    mortgageHTALP: function(){
      if(this.withdrawNumber>this.HTALPBalance) return this.showSendBox(false, '余额不足')
      this.contracts.HTBetaIns.mortgageAlphaLP(this.withdrawNumber * 10 ** 18).then(this.success, this.fail)
    },
    withdrawHTALP: function(){
      if(this.withdrawNumber>this.HTALPMortgage) return this.showSendBox(false, '可提现余额不足')
      this.contracts.HTBetaIns.withdrawAlphaLP(this.withdrawNumber * 10 ** 18).then(this.success, this.fail)
    },
    settlementBeta: function(){
      if(this.HTBSettleable<=0) return this.showSendBox(false, '可结算余额不足')
      this.contracts.HTBetaIns.settlementBeta().then(this.success, this.fail)
    },
    mortgageHTBLP: function(){
      if(this.withdrawNumber>this.HTBLPBalance) return this.showSendBox(false, '余额不足')
      this.contracts.HTCubeIns.mortgageBetaLP(this.withdrawNumber * 10 ** 18).then(this.success, this.fail)
    },
    withdrawHTBLP: function(){
      if(this.withdrawNumber>this.HTBLPMortgage) return this.showSendBox(false, '可提现余额不足')
      this.contracts.HTCubeIns.withdrawBetaLP(this.withdrawNumber * 10 ** 18).then(this.success, this.fail)
    },
    settlementCube: function(){
      if(this.HTCSettleable<=0) return this.showSendBox(false, '可结算余额不足')
      this.contracts.HTCubeIns.settlementCube().then(this.success, this.fail)
    },
    approveHTALP: function(){
      this.contracts.HTALPIns.approve(this.contracts.HTBeta.address, max).then(this.success, this.fail)
    },
    approveHTBLP: function(){
      this.contracts.HTBLPIns.approve(this.contracts.HTCube.address, max).then(this.success, this.fail)
    },
    boostBeta: function(){
      this.closePop()
      let cube = this.option?this.advanceTimeCube:this.multipleCube
      if(cube>this.HTCBalance) return this.showSendBox(false, '余额不足')
      this.contracts.HTBetaIns.boostBeta(this.option).then(this.success, this.fail)
    },
    submit: function(){
      this.closePop()
      if(!this.withdrawNumber) return this.showSendBox(false, '请输入正确数字')
      let prefix = this.isWithdraw?'withdraw':'mortgage'
      this[prefix + this.currency]()
    },
    checkAccount: function () {
      window.web3.eth.defaultAccount = this.account = window.web3.eth.coinbase
      setInterval(() => {
        if (this.account !== window.web3.eth.coinbase) {
          window.web3.eth.defaultAccount = this.account = window.web3.eth.coinbase
          window.location.reload()
        }
      }, 3000)
    },
    initSuperiorID: function () {
      let reg = new RegExp('(^|&)' + 'id' + '=([^&]*)(&|$)')
      let r = window.location.search.substr(1).match(reg)
      this.superiorID = r!=null?decodeURIComponent(r[2]):'0x'+'0'.repeat(40)
    },
    getLink: function () {
      let url = window.location.href
      if (url.indexOf('?') !== -1) {
        let offset = url.indexOf('?')
        url = url.substr(0, offset)
      }
      return url + '?id=' + this.account
    },
    copy: function () {
      let clipboard = new window.ClipboardJS('.btn')
      clipboard.on('success', e => {
        e.clearSelection()
        this.showSendBox(true)
        clipboard.destroy()
      })
      clipboard.on('error', e => {
        this.showSendBox(false)
        clipboard.destroy()
      })
    },
    getSwapUrl: function(v){
      return `https://ht.mdex.com/#/swap?outputCurrency=${this.addrs[v]}`
    },
    getAddLPUrl: function(v){
      return `https://ht.mdex.com/#/add/${this.addrs[v]}/HT`
    },
    getContractUrl: function(v){
      return `https://scan.hecochain.com/address/${this.addrs[v]}#contracts`
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
