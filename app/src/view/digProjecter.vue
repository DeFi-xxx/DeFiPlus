<template>
    <div class="project">
        <div class="promise">
            <div class="rightPage" @click="toPage()">
                我是项目方
            </div>
        </div>
        <div class="line"></div>
        <div class="container" v-show="isPopupVisible">
        <div class="popup">
          <section class="popup-body">
            <input type="text" v-model="num">
            <button
              type="button"
              class="btn-green"
              @click="closePopup">取消
              </button>
              <button
              type="button"
              class="btn-green"
              @click="stake(num)">确定
              </button>
          </section>
        </div>
      </div>
        <div v-for="(item,index) in addressArr">
            <div class="promise">
                <div class="promiseBox">
                    <div class="text" style="border:1px;width:150px; white-space:nowrap;text-overflow:ellipsis;overflow:hidden; ">{{item}}</div>
                </div>
            </div>
            <div class="box">
                <div class="top">
                    <div class="item">
                        <div >{{deposits[index]}}</div>
                        <div>存入信息</div>
                    </div>
                    <div class="item">
                        <div style="color: #00E3B6" >{{incomes[index]}}</div>
                        <div>收益信息</div>
                    </div>
                </div>
                <div class="btns">
                    <div class="btn" @click="showPopup(index)">存入</div>
                    <div class="btn" @click="withraw(index)">领取</div>
                    <div class="btn" @click="exit(index)">退出</div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { ethers } from 'ethers';
import Web3 from "web3";
import IERC20 from "../../../build/contracts/IERC20.json";
import Allocation1 from "../../../build/contracts/FirstAllocation.json";
const provider = new ethers.providers.Web3Provider(web3.currentProvider);
const signer = provider.getSigner();

    export default {
        name: "projecter",
        data(){
            return{
                web3: null,
                firstAllocation: "0xc62891B040Bac903851ff09C6EA70a2c3c87C42e",
                addressArr: [],
                deposits: [],
                incomes: [],
                isPopupVisible: false,
			    num: 1e18,
                poolIndex: 0,


            }
        },
        created(){
            window.ethers = ethers;
            window.signer = signer;
            if (window.ethereum) {
                // use MetaMask's provider
                this.web3 = new Web3(window.ethereum);
                window.ethereum.enable(); // get permission to access accounts
            } else {
                console.warn(
                "No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live",
                );
                // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
                this.web3 = new Web3(
                new Web3.providers.HttpProvider("http://127.0.0.1:8545"),
                );
            }
            window.web3 = this.web3;
            this.getPoolInfo();
        },
        methods:{
            toPage(){
                this.$router.push('/dig')
            },
            async getPoolInfo() {
                let addr = await signer.getAddress();
                let allocationContract = new ethers.Contract(this.firstAllocation, Allocation1.abi, provider);
                let allocationContractWithSigner = allocationContract.connect(signer);
                let length = await allocationContract.poolLength();
                this.addressArr = [];
                this.deposits = [];
                this.incomes = [];
                for(let i = 0; i < this.hexToNumber(length._hex); i++) {
                    let poolInfo = await allocationContract.poolInfo(this.numberToHex(i));
                    this.addressArr.push(poolInfo.rewardToken);
                    let deposit = await allocationContractWithSigner.getDepositInfo(this.numberToHex(i));
                    console.log(deposit);
                    this.deposits.push(deposit);
                    let hash = await ethers.utils.solidityKeccak256(["address", "address"], [poolInfo.lpToken, poolInfo.rewardToken]);
                    let income = await allocationContract.earned(addr, hash);
                    this.incomes.push(income);
                }
            },
            async stake(amount) {
                let allocationContract = new ethers.Contract(this.firstAllocation, Allocation1.abi, provider);
                let poolInfo = await allocationContract.poolInfo(this.poolIndex);
                let lpToken = poolInfo.lpToken;
                let rewardToken = poolInfo.rewardToken;
                let hash = ethers.utils.solidityKeccak256(["address", "address"], [lpToken, rewardToken]);
                let allocationContractWithSigner = allocationContract.connect(signer);
                let result = await allocationContractWithSigner.stake(this.numberToHex(amount), hash);
                console.log(result);
                this.isPopupVisible = false
            },
            async withraw(index) {
                let allocationContract = new ethers.Contract(this.firstAllocation, Allocation1.abi, provider);
                let poolInfo = await allocationContract.poolInfo(index);
                let lpToken = poolInfo.lpToken;
                let rewardToken = poolInfo.rewardToken;
                let hash = ethers.utils.solidityKeccak256(["address", "address"], [lpToken, rewardToken]);
                let allocationContractWithSigner = allocationContract.connect(signer);
                await allocationContractWithSigner.getReward(hash);
            },
            async exit(index) {
                let allocationContract = new ethers.Contract(this.firstAllocation, Allocation1.abi, provider);
                let poolInfo = await allocationContract.poolInfo(index);
                let lpToken = poolInfo.lpToken;
                let rewardToken = poolInfo.rewardToken;
                let hash = ethers.utils.solidityKeccak256(["address", "address"], [lpToken, rewardToken]);
                let allocationContractWithSigner = allocationContract.connect(signer);
                await allocationContractWithSigner.exit(hash);
            },
            numberToHex(num) {
                return this.web3.utils.numberToHex(num);
            },
            hexToNumberString(hex) {
                return this.web3.utils.hexToNumberString(hex);
            },
            hexToNumber(hex) {
                return this.web3.utils.hexToNumber(hex);
            },
            showPopup(index){
                this.poolIndex = index;
                this.isPopupVisible = true
            },
            closePopup(){
                this.isPopupVisible = false
            }
        }
    }
</script>

<style scoped>
    .project{
        background: url("/img2/bg3.png");
        background-size: 100% 100%;
        padding-bottom: 1px;
        width: 343px;
        margin: 13px auto;
    }
    .promiseBox{

    }
    .rightPage{
        color:#FA8C16;
        font-size: 9px;
        padding: 5px 11px;
        border: 1px solid #FA8C16;
        float: right;
        margin-top: 14px;
        margin-right: 23px;
        border-radius: 4px;
    }
    .promiseBox{
        clear: both;
        padding-top: 10px;
        padding-left: 40px;
    }
    .hsize{
        font-size: 14px;
        color: #FFFFFF;
        font-weight: bold;
        margin-bottom: 8px;
    }
    .text{
        font-size: 12px;
        color: #E9EDF7;
        margin: 5px 0;
    }
    .chosen{
        background: #00E3B6;
        color: black;
        font-size: 12px;
        margin: 15px auto;
        width: 100px;
        height:33px;
        border-radius:4px;
        line-height: 33px;
        text-align: center;
        font-weight: bold;
    }
    .box{
        background: #FFFFFF;
        margin: 0 10%;
        padding: 20px 0;
        border-radius: 12px;
    }
    .top{
        display: flex;
        justify-content: space-around;
        color: #19233E;
        margin: 0 10% 10px 10%;
        padding: 10px 0;
        text-align: center;
    }
    .top .item div:nth-child(1){
        font-weight: bold;
        margin-bottom: 5px;
    }
    .box .btn{
        background: #00E3B6;
        color: #19223E;
        width: 145px;
        height: 33px;
        display: flex;
        justify-content: center;
        align-items: center;
        margin: auto;
        border-radius: 4px;
    }
    .line{
        background: #00E3B6;
        width: 266px;
        height: 2px;
        margin: 40px auto;
        border-radius: 95%;
        box-shadow: 0 0 5px;
    }
    .btns{
        display: flex;
        justify-content: space-between;
    }
    .btns .btn{
        width: 66px;
    }
    .a {
      /* position: fixed; */
      
       display: flex;
      justify-content: center;
      align-items: center;
    }
    .popup {
      background: #FFFFFF;
      box-shadow: 2px 2px 20px 1px;
      overflow-x: auto;
      display: flex;
      flex-direction: column;
    }
    .popup-header, .popup-footer{
      padding: 15px;
      display: flex;
    }
    .popup-header {
      border-bottom: 1px solid #eeeeee;
      color: #4AAE9B;
      justify-content: space-between;
    }
    .popup-footer {
      border-top: 1px solid #eeeeee;
      justify-content: flex-end;
    }
    .popup-body {
      position: relative;
      padding: 6px 61px 7px 11px;
    }
    .btn-close {
      border: none;
      font-size: 20px;
      padding: 20px;
      cursor: pointer;
      font-weight: bold;
      color: #4AAE9B;
      background: transparent;
    }
    .btn-green {
      color: white;
      background: #4AAE9B;
      border: 1px solid #4AAE9B;
      border-radius: 2px;
        padding: 2px 9px 2px 9px;
        margin: 1px 1px 1px 10px;
    } 
</style>