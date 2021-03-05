<template>
    <div class="body">
        <div class="promise">
            <div class="rightPage" @click="toPage()">
                领空投
            </div>
            <input   id="inputAddress"  placeholder="请输入合约地址进行授权"      maxlength="30" />
            <div class="chosen" @click="submit()">已授权</div>
        </div>
        <div class="projectMes">
            <input class="input"  placeholder="请输入Token合约地址"      maxlength="30"/>
            <input class="input" placeholder="空投数量" />
<!--            <select id="secWay">-->
<!--                <option  style="display:none"  value="">选择空投方式</option>-->
<!--                <option :value="coupon.id" v-for="coupon in couponList">5</option>-->
<!--                <option value="2">12</option>-->
<!--            </select>-->
            <select id="secWay" v-model="selected" @change="getSelected()">
                <option v-for="item in list" :style="{display:item.id==0?'none':'block'}"  :value="item.id" >{{item.name}}</option>
            </select>
        </div>
    </div>
</template>

<script>
    export default {
        name: "airdrop",
        data(){
            return{
                selected:'0',
                list:[
                    {
                        id: '0',
                        name: '选择空投方式'
                    },
                    {
                        id: '1',
                        name: 'zzz'
                    },
                    {
                        id: '3',
                        name: 'yyy'
                    },
                    {
                        id: '2',
                        name: 'ccc'
                    },
                ]
            }
        },
        created(){
            //如果没有这句代码，select中初始化会是空白的，默认选中就无法实现
            this.selected = '2';
        },
        methods:{
            toPage(){
                this.$router.push('/airdropProjecter')
            },
            getSelected(e){
                // this.selected =
                console.log(11111)
                console.log(e,this.selected)
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