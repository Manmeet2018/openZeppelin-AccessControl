const MyToken = artifacts.require('MyToken');
// const accounts = web3.eth.getAccounts();
module.exports = function (deployer) {
  deployer.deploy(MyToken);
};
