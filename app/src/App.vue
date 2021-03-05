<template>
    <div id="app">
        <div class="head">
            <div class="left">
                <img src="img2/logo.png">
            </div>
            <div class="right">
                <!-- <div class="item" :class="index==0?'active':''" @click="pageTo('getHt',0)">领HT</div> -->
                <div class="item" :class="index==1?'active':''" @click="pageTo('airdrop',1)">空投</div>
                <div class="item" :class="index==2?'active':''" @click="pageTo('dig',2)">挖矿</div>
            </div>
        </div>
        <router-view/>
    </div>
</template>

<script>
    export default {
        name: 'app',
        data() {
            return {
                index: 0,
            }
        },
        methods: {
            pageTo(url, index) {
                this.$router.push('/' + url)
                this.index = index
            }
        }
    }
</script>

<style scoped>
    @import "./css/css.css";

    * {
        margin: 0;
        padding: 0;
    }

    .head {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 343px;
        margin: 0 auto;
    }

    .head .left {

    }

    .head .left img {
        width: 116px;
        height: 47px;
    }

    .head .right {
        display: flex;
        justify-content: space-around;
        margin-top: auto;
    }

    .head .right .item {
        color: #EFEFEF;
        border: 1px solid #EFEFEF;
        padding: 2px 10px;
        margin: auto 5px;
    }

    .head .right .item.active {
        color: #00FFCC;
        border: 1px solid #00FFCC;

    }
</style>
