<template>
    <div class="body">
        <div class="promise">
            <div class="rightPage" @click="toPage()">
                领空投
            </div>
        </div>
        <div class="projectMes">
            <input class="input" v-model="token"  placeholder="请输入Token合约地址" />
            <input class="input" v-model="amount" placeholder="空投数量" />
            <input class="input" v-model="value" placeholder="人/数量" />

            <select id="secWay" v-model="selected" @change="getSelected()">
                <option v-for="item in list" :style="{display:item.id==0?'none':'block'}"  :value="item.id" >{{item.name}}</option>
            </select>
            <div class="chosen" @click="submit1()">授权</div>
            <div class="chosen" @click="submit2()">发放空投</div>
        </div>
    </div>
</template>

<script>
import { ethers } from 'ethers';
import Web3 from "web3";
import IERC20 from "../../../build/contracts/IERC20.json";
import Controller from "../../../build/contracts/Controller.json";
const provider = new ethers.providers.Web3Provider(web3.currentProvider);
const signer = provider.getSigner();
    export default {
        name: "airdrop",
        data(){
            return{
                token: "0xcf3379feefd55ab18333f947bd2d54e3a6dd954f",
                amount: this.scientificNumber(10000000000000000000000),
                controller: "0xC1bB3978f3A5Cd727527Cc82F4E07db41E0B94E7",
                value: this.scientificNumber(1000000000000000000),
                selected:'0',
                list:[
                    {
                        id: '0',
                        name: '选择空投方式'
                    },
                    {
                        id: '1',
                        name: '1'
                    },
                    {
                        id: '3',
                        name: '2'
                    },
                    {
                        id: '2',
                        name: '3'
                    },
                ]
            }
        },
        created(){
            //如果没有这句代码，select中初始化会是空白的，默认选中就无法实现
            this.selected = '1';
            window.ethers = ethers;
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
        },
        methods:{
            toPage(){
                this.$router.push('/airdropProjecter')
            },
            getSelected(e){
                // this.selected =
                console.log(11111)
                console.log(e,this.selected)
            },
            async submit1() {
                let allocationContract = new ethers.Contract(this.token, IERC20.abi, provider);
                let allocationContractWithSigner = allocationContract.connect(signer);
                let resutl = await allocationContractWithSigner.approve(this.controller, this.numberToHex(this.amount));
            },
            async submit2() {
                let allocationContract = new ethers.Contract(this.token, Controller.abi, provider);
                let allocationContractWithSigner = allocationContract.connect(signer);
                await allocationContractWithSigner.airdrop(
                    this.token,
                    this.numberToHex(this.amount),
                    this.numberToHex(this.value),
                    0,
                    "0x0000000000000000000000000000000000000000000000000000000000000000"
                );
                console.log("发放");
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
            scientificNumber (num) {
                if (!num) return num
                const str = num.toString()
                const reg = /^(\d+)(\.\d+)?(e)([+]?\d+)$/
                const reg2 = /^(\d+)(\.\d+)?(e)([-]?\d+)$/
                let arr
                let len
                let zero = ''
                if (reg.test(str)) {
                arr = reg.exec(str)
                // 保留小数位数
                const arr2 = arr[2] ? arr[2].replace('.', '') : ''
                // 此处减去arr2的长度为了兼容有小数情况
                len = Math.abs(arr[4]) - (arr2.length || 0)
                for (var i = 0; i < len; i++) {
                    zero += '0'
                }
                return arr[1] + arr2 + zero
                } else if (reg2.test(str)) {
                arr = reg2.exec(str)
                len = Math.abs(arr[4]) - 1
                const arr2 = arr[2] ? arr[2].replace('.', '') : ''
                for (let index = 0; index < len; index++) {
                    zero += '0'
                }
                return '0.' + zero + arr[1] + arr2
                } else {
                return num
                }
            }
        }
    }
</script>

<style scoped>
    .body{
        padding: 0;
        margin: 0;
    }
    .promise{
 
        background-size: 100% 100%;
        width:343px;
        height: auto;
        margin: 13px auto;
        padding-bottom: 20px;
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
    #inputAddress{
        width: 300px;
        height:31px;
        border: 1px solid #E8EDF0;
        color: white;
        font-family: PingFang SC;
        font-weight: bold;
        clear: both;
        margin: 20px 20px;

    }
    input::-webkit-input-placeholder{
        color:rgba(0,0,0,0.5);
        text-indent: 1em;
    }
    .chosen{
        background: #00E3B6;
        color: black;
        font-size: 12px;
        margin: 0 auto;
        width: 100px;
        height:33px;
        border-radius:4px;
        line-height: 33px;
        text-align: center;
        font-weight: bold;
    }
    .projectMes{
        background: url("/img2/bg4.png");
        background-size: 100% 100%;
        height: 200px;
        width:343px;
        flex-direction: column;
        margin: 20px auto;
        justify-content: center;
        align-items: center;
    }

    .input{
        background: rgba(233, 237, 247, 0.2);
        width: 320px;
        height: 36px;
        margin: 10px 10px;
        border: 0px solid #E8EDF0;
        text-indent: 1em;
        color: #FFFFFF;
    }
    .input::-webkit-input-placeholder{
        color: rgba(255, 255, 255, 0.5);
        text-indent: 1em;
    }
    #secWay{
        border-radius: 4px;
        border: 1px solid #ffffff;
        width: 320px;
        height:45px;
        margin: 10px 10px;
        text-indent: 1em;
        color: rgba(255,255,255,0.5);
        background: rgba(66, 93, 117, 1);
        border: 0px solid #E8EDF0;
    }
    option{
        color: rgba(255,255,255,0.5);
        background: rgba(233, 237, 247, 0.2);
        height:45px;
    }
</style>