// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";

  contract TokenFactory {
    mapping(uint256 => Token) tokens;
    mapping(address => bool) tokenAddress;
    
    uint256 private _totalTokens;
    
    event TokenCreated(address owner, Token token);
    
    
    function isPresent(Token token) internal view returns (bool) {
        return (tokenAddress[address(token)]);
    }
    
    modifier isValidToken(address token) {
        require(token != address(0), "ERC20: Can't pause token of zero address");
        require(isPresent(Token(token)), "ERC20: Token not present");
        _;
    }
    
    function createToken(address _minter, address _burner, uint256 _cap) external {
        Token token  = new Token(_minter, _burner, _cap);
        tokens[_totalTokens] = token;
        tokenAddress[address(token)] = true;
        _totalTokens++;
        emit TokenCreated(msg.sender, token);
    }
    
    function deployedTotalSupply() public view returns (uint256) {
        uint256 totalDeployedTokens = 0;
        for(uint256 i = 0; i < _totalTokens; ++i) {
            Token myToken = Token(tokens[i]);
            totalDeployedTokens += myToken.totalSupply();
        }
        return totalDeployedTokens;
    }
    
    function pause(address token) public isValidToken(token) {
        Token myToken = Token(token);
        myToken.pause();
    }
    
    function unpause(address token) public isValidToken(token) {
        Token myToken = Token(token);
        myToken.unpause();
    }
}
