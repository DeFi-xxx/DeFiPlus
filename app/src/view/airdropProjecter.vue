<template>
    <div class="airdrop">
        <div class="promise">
            <div class="rightPage" @click="toPage()">
                我是项目方
            </div>
            <div class="progress">
                <div class="row1">
                    <div>HTCube</div>
                    <img src="/img2/iconTime.png"/>
                    <div style="color: #00E3B6;font-size: 11px">进行中</div>
                </div>
                <div class="row2">
                    <div class="line" :style="getWith()"></div>
                </div>
                <div class="row3">
                    <div style="color: #00FFCC">500HTC</div>
                    <div>100HTC</div>
                </div>
            </div>
            <div class="chosen" @click="submit()">领取</div>
            <transition name="draw">
                <div class="info" v-if="flag">
                    <div class="hsize">HTCube</div>
                    <div class="text">Token合约地址：0xxxxxxxxx</div>
                    <div class="text">项目信息：叭叭叭叭了个叭叭</div>
                    <div class="text">空投方式：按账号余额排名，取Top1000</div>
                </div>
            </transition>
            <img @click="change" class="openInfo" :src="'/img2/'+(flag?'close':'open')+'.png'"/>
        </div>
    </div>
</template>

<script>
    export default {
        name: "airdropProjecter",
        data(){
           return{
               flag: false,
           }
        },
        methods:{
            toPage(){
                this.$router.push('/airdrop')
            },
            getWith(){
                var width = Math.floor(Math.random() * 100)
                return `width: ${width}%`
            },
            change(){
                this.flag = !this.flag;

            }
        }
    }
</script>

<style scoped>
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
    .progress{
        clear: both;
        padding: 10px 40px;
    }
    .progress .row1{
        display: flex;
        align-items: center;
    }
    .progress .row1 img{
        width: 15px;
        height: 15px;
        margin-left: 10px;
        margin-right: 3px;
    }
    .progress .row2{
        background: #192440;
        width: 263px;
        height: 10px;
        border-radius: 10px;
        margin: 15px 0;
    }
    .progress .row2 .line{
        background: linear-gradient(-90deg, #00FFCC, rgba(76, 236, 255, 0));
        height: 100%;
        border-radius: 10px;
    }
    .progress .row3{
        display: flex;
        justify-content: space-between;
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
    .openInfo{
        width: 15px;
        height: 12px;
        display: flex;
        margin: 0px auto;
        padding: 30px;
    }
    .info{
        padding-top: 10px;
        padding-left: 40px;
        height: 100px;
        overflow: hidden;
    }
    .draw-enter-active, .draw-leave-active {
        transition: all 1s ease;
    }
    .draw-enter, .draw-leave-to {
        height: 0;
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
</style>