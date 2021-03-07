<template>
	<div class="project">
		<div class="promise">
			<div class="rightPage" @click="toPage()">
				我是项目方
			</div>
		</div>
		<div class="line"></div>
		<!-- <div style="background: red" v-show="isPopupVisible">
            <h1>xxxx</h1> -->
		<!-- <div class="popup">
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
        </div> -->
		<!-- </div> -->
		<div v-for="(item,index) in addressArr">
			<div class="promise">
				<div class="promiseBox">
					<div class="text" style="border:1px;width:150px; white-space:nowrap;text-overflow:ellipsis;overflow:hidden; ">{{item.rewardToken}}</div>
				</div>
			</div>
			<div class="box">
				<div class="top">
					<div class="item">
						<div>{{keepTwoDecimalFull(deposits[index]/10**18)}}</div>
						<div>存入信息</div>
					</div>
					<div class="item">
						<div style="color: #00E3B6">{{keepTwoDecimalFull(incomes[index]/10**18)}}</div>
						<div>收益信息</div>
					</div>
				</div>
				<div v-show="item.isPopupVisible">
					<div style="display: flex;flex-direction: row;box-sizing: border-box;padding: 20px;margin: 10px 0;">
						<input type="text" style="width: 40%;" v-model="num">
						<button style="flex: 2;" type="button" class="btn-green" @click="closePopup(item,index)">取消
						</button>
                        <button style="flex: 2;" type="button" class="btn-green" @click="approve(num)">授权
						</button>
						<button style="flex: 2;" type="button" class="btn-green" @click="stake(num)">确定
						</button>
					</div>
				</div>
				<div class="btns">
					<div class="btn" @click="showPopup(item,index)">存入</div>
					<div class="btn" @click="withraw(index)">领取</div>
					<div class="btn" @click="exit(index)">退出</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	import {
		ethers
	} from 'ethers';
	import Web3 from "web3";
	import IERC20 from "../../../build/contracts/IERC20.json";
	import Allocation1 from "../../../build/contracts/FirstAllocation.json";
	const provider = new ethers.providers.Web3Provider(web3.currentProvider);
	const signer = provider.getSigner();

	export default {
		name: "projecter",
		data() {
			return {
				web3: null,
				firstAllocation: "0x2e945707010B5279C498dAB018a48c3277946B57",
				addressArr: [],
				deposits: [],
				incomes: [],
				isPopupVisible: false,
				num: 1,
				poolIndex: 0,


			}
		},
		created() {
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
		methods: {
			toPage() {
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
				this.popupVisible = [];
				for (let i = 0; i < this.hexToNumber(length._hex); i++) {
					let poolInfo = await allocationContract.poolInfo(this.numberToHex(i));
					// poolInfo.isPopupVisible = false
					// this.addressArr.push(poolInfo.rewardToken);
					this.addressArr.push({
						isPopupVisible: false,
						rewardToken: poolInfo.rewardToken
					});
					let deposit = await allocationContractWithSigner.getDepositInfo(this.numberToHex(i));
					console.log(deposit);
					this.deposits.push(deposit);
					let hash = await ethers.utils.solidityKeccak256(["address", "address"], [poolInfo.lpToken, poolInfo.rewardToken]);
					let income = await allocationContract.earned(addr, hash);
					this.incomes.push(income);
				}
				console.log(this.addressArr)

			},
            async approve(amount) {
				amount = amount * 10 ** 18;
                
				let allocationContract = new ethers.Contract(this.firstAllocation, Allocation1.abi, provider);
				let poolInfo = await allocationContract.poolInfo(this.poolIndex);
				let lpToken = poolInfo.lpToken;
				let rewardToken = poolInfo.rewardToken;
                let erc20Contract = new ethers.Contract(poolInfo.lpToken, IERC20.abi, provider);
                let erc20ContractWithSigner = erc20Contract.connect(signer);
                await erc20ContractWithSigner.approve(this.firstAllocation, this.numberToHex(this.scientificNumber(amount)));
			},
			async stake(amount) {
				amount = amount * 10 ** 18;
                
				let allocationContract = new ethers.Contract(this.firstAllocation, Allocation1.abi, provider);
				let poolInfo = await allocationContract.poolInfo(this.poolIndex);
				let lpToken = poolInfo.lpToken;
				let rewardToken = poolInfo.rewardToken;
				let hash = ethers.utils.solidityKeccak256(["address", "address"], [lpToken, rewardToken]);
				let allocationContractWithSigner = allocationContract.connect(signer);
				let result = await allocationContractWithSigner.stake(this.numberToHex(this.scientificNumber(amount)), hash);
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
            },
			showPopup(item, index) {
				this.poolIndex = index
				item.isPopupVisible = true
			},
			closePopup(item,index) {
				item.isPopupVisible = false
			},
			keepTwoDecimalFull(num) {
			var result = parseFloat(num);
			if (isNaN(result)) {
				return 0.00;
			}
			result = Math.round(num * 100) / 100;
			var s_x = result.toString();
			var pos_decimal = s_x.indexOf('.');
			if (pos_decimal < 0) {
				pos_decimal = s_x.length;
				s_x += '.';
			}
			while (s_x.length <= pos_decimal + 2) {
				s_x += '0';
			}
				return s_x;
			}
		}
	}
</script>

<style scoped>
	.project {
		background: url("/img2/bg3.png");
		background-size: 100% 100%;
		padding-bottom: 1px;
		width: 343px;
		margin: 13px auto;
	}

	.promiseBox {}

	.rightPage {
		color: #FA8C16;
		font-size: 9px;
		padding: 5px 11px;
		border: 1px solid #FA8C16;
		float: right;
		margin-top: 14px;
		margin-right: 23px;
		border-radius: 4px;
	}

	.promiseBox {
		clear: both;
		padding-top: 10px;
		padding-left: 40px;
	}

	.hsize {
		font-size: 14px;
		color: #FFFFFF;
		font-weight: bold;
		margin-bottom: 8px;
	}

	.text {
		font-size: 12px;
		color: #E9EDF7;
		margin: 5px 0;
	}

	.chosen {
		background: #00E3B6;
		color: black;
		font-size: 12px;
		margin: 15px auto;
		width: 100px;
		height: 33px;
		border-radius: 4px;
		line-height: 33px;
		text-align: center;
		font-weight: bold;
	}

	.box {
		background: #FFFFFF;
		margin: 0 10%;
		padding: 20px 0;
		border-radius: 12px;
	}

	.top {
		display: flex;
		justify-content: space-around;
		color: #19233E;
		margin: 0 10% 10px 10%;
		padding: 10px 0;
		text-align: center;
	}

	.top .item div:nth-child(1) {
		font-weight: bold;
		margin-bottom: 5px;
	}

	.box .btn {
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

	.line {
		background: #00E3B6;
		width: 266px;
		height: 2px;
		margin: 40px auto;
		border-radius: 95%;
		box-shadow: 0 0 5px;
	}

	.btns {
		display: flex;
		justify-content: space-between;
	}

	.btns .btn {
		width: 66px;
	}

	.a {
		position: fixed;

		top: 40%;
		left: 29%;
		right: 29%;
		bottom: 61px;
		transform: translate(-50, -50%);
		/* display: flex;
      justify-content: center;
      align-items: center; */

	}

	.popup {
		background: #FFFFFF;
		box-shadow: 2px 2px 20px 1px;
		overflow-x: auto;
		display: flex;
		flex-direction: column;
	}

	.popup-header,
	.popup-footer {
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
		/* position: relative; */
		padding: 6px 23px 6px -1px;
		background-color: red;
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
		margin: 0 5px;
	}
</style>
