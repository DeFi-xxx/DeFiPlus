<template>
    <div class="wrap">
        <div class="main">
            <div class="content">
                {{title}}
            </div>
            <div class="btn-grounp">
                <div class="btn cancel" @click="cancel">{{cancelText}}</div>
                <div class="btn confirm" @click="confirm">{{confirmText}}</div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name:'',
    data () {
        return {
            title:'这是一个弹窗',
            confirmText:'确定',
            cancelText:'取消'
        };
    },
    methods: {
        show(cb){
            typeof cb === 'function' && cb.call(this,this)
            return new Promise(resolve=>{
                this.resolve = resolve
            })
        },
        confirm(){
            this.resolve('confirm')
            this.hide()
        },
        cancel(){
            this.resolve('cancel')
            this.hide()
        },
        hide(){
            document.body.removeChild(this.$el)
            this.$destroy()
        }
    },
}

</script>

<style scoped>
.wrap{
    position: fixed;
    top: 0;
    bottom:0;
    left:0;
    right:0;
    display:flex;
    justify-content: center;
    align-items: center;
    background: rgba(0,0,0,.3);
}
.main{
    width: 30%;
    padding: 10px;
    background: #fff;
    box-shadow: 0 0 10px 1px #ddd;
    border-radius: 5px;
}
.content{
    color:#424242;
    font-size: 20px;
}
.btn-grounp{
    margin-top: 15px;
    display:flex;
    justify-content: flex-end;
}
.btn{
    margin-left: 15px;
    padding: 5px 20px;
    border-radius: 5px;
    font-size: 16px;
    color:#fff;
}
.confirm{
    background: lightblue;
}
.cancel{
    background: lightcoral;
}
</style>