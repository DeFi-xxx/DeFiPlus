<template>
    <div class="body">
        <div class="promise">
            <div class="rightPage" @click="toPage()">
                去挖矿
            </div>
            <input   id="inputAddress"  placeholder="质押的Token地址" v-model="stakeToken"  />
            
            <input   id="inputAddress"  placeholder="挖取的Token地址" v-model="rewardToken"  />

            <input   id="inputAddress"  placeholder="挖取的Token总量" v-model="rewardAmount"  />

            <input   id="inputAddress"  placeholder="开始时间" v-model="startTime"  />

        </div>
        <div class="projectMes">
            选择挖矿模式
            <select id="sec" v-model="mineWay" >
                <option value = "1" selected>1</option>
                <option value = "2">2</option>
            </select>

            
            <div class="proDay">
                <h2 style="color: #19223E;text-align: left;font-size: 16px;">参数</h2>
                <div class="dayPost" v-if="mineWay == 1">
                    <span>挖矿持续时间:</span>
                    <input  placeholder="天数"  id="everyProduct"  />
                </div>

                <div class="dayPost" v-else>
                    <span>每天:</span>
                    <input  placeholder="建议30天"  id="everyProduct"  />
                    <span>总量：100</span>
                </div>

                <div class="chosen" @click="submit()">授权</div>
            </div>
        </div>
    </div>


</template>

<script>
import { ethers } from 'ethers';
import Web3 from "web3";
import IERC20 from "../../../build/contracts/IERC20.json";
const provider = new ethers.providers.Web3Provider(web3.currentProvider);
const signer = provider.getSigner();

    export default {
        name: "dig",
        data(){
            return{
                web3: null,
                stakeToken: "",
                rewardToken: "0x337610d27c682e347c9cd60bd4b3b107c9d34ddd",
                rewardAmount: 0,
                startTime: 0,
                firstAllocation: "0x1acb54865e710c6cf8522582de51074d7dE33339",
                secondAllocation: "0x0E02a99F18c476a42e73F731228f25948Aaea155",
                mineWay: 1,
            }
        },
        created(){
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
            async submit(){
                let contract = new ethers.Contract(this.rewardToken, IERC20.abi, provider);
                let totalSupply = await contract.totalSupply();
                
                totalSupply = this.web3.utils.hexToNumberString(totalSupply._hex);
                console.log(totalSupply);
                let contractWithSigner = contract.connect(signer);
                let result = await contractWithSigner.approve(this.firstAllocation, this.web3.utils.numberToHex(10e18));
                console.log(result);

            },
            toPage(){
                this.$router.push('/digProjecter')
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
    background: url("/img2/bg1.png");
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
        background: url("/img2/bg2.png");
        background-size: 100% 100%;
        background-color:rgba(29,57,102,1);
        height: 500px;
        width:343px;
        margin: 20px auto;
    }
    #sec{
        border-radius: 4px;
        border: 1px solid #ffffff;
        width: 320px;
        height:45px;
        margin: 20px 10px;
        text-indent: 1em;
        color: rgba(255,255,255,0.5);
        background: rgba(233, 237, 247, 0.2);
    }
    option{
        color: rgba(255,255,255,0.5);
        background: rgba(233, 237, 247, 0.2);
    }
    #secWay{
        border-radius: 4px;
        border: 1px solid #ffffff;
        width: 320px;
        height:45px;
        margin: 0px 10px;
        text-indent: 1em;
        color: rgba(255,255,255,0.5);
        background: rgba(233, 237, 247, 0.2);
    }
    .proDay{
        border: 1px solid white;
        border-radius: 5px;
        padding: 0px 10px;
        margin: 20px auto;
        background: white;
        height: auto;
    }
    .dayPost{
        border: 1px solid #8D9199;
        border-radius: 4px;
        color: black;
        font-size: 11px;
        text-indent: 1em;
        padding: 8px 0px;
        margin-bottom: 5px;
    }
    #everyProduct{
        border: none;
    }
</style>