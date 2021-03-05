<template>
    <div class="project">
        <div class="promise">
            <div class="rightPage" @click="toPage()">
                我是项目方
            </div>
            <div class="promiseBox">
                <div class="hsize">HTCube</div>
                <div class="text">Token合约地址：0xxxxxxxxx</div>
                <div class="text">项目信息：叭叭叭叭了个叭叭</div>
                <div class="text">空投方式：按账号余额排名，取Top1000</div>
            </div>
            <div class="chosen" @click="submit()">收起挖矿</div>
        </div>
        <div class="box">
            <div class="top">
                <div class="item">
                    <div>0.000000</div>
                    <div>收入代币</div>
                </div>
                <div class="item">
                    <div style="color: #00E3B6">0.000000</div>
                    <div>取得收益</div>
                </div>
            </div>
            <div class="btn">授权</div>
        </div>
        <div class="line"></div>
        <div class="promise">
            <div class="promiseBox">
                <div class="hsize">HTCube</div>
                <div class="text">Token合约地址：0xxxxxxxxx</div>
                <div class="text">项目信息：叭叭叭叭了个叭叭</div>
                <div class="text">空投方式：按账号余额排名，取Top1000</div>
            </div>
            <div class="chosen" @click="submit()">收起挖矿</div>
        </div>
        <div class="box">
            <div class="top">
                <div class="item">
                    <div>0.000000</div>
                    <div>收入代币</div>
                </div>
                <div class="item">
                    <div style="color: #00E3B6">0.000000</div>
                    <div>取得收益</div>
                </div>
            </div>
            <div class="btns">
                <div class="btn">存入</div>
                <div class="btn">取收益</div>
                <div class="btn">全部取出</div>
            </div>

        </div>
    </div>
</template>

<script>
    export default {
        name: "projecter",
        methods:{
            toPage(){
                this.$router.push('/dig')
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
</style>