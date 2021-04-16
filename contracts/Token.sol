// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "../interface/IToken.sol";

 contract Token is AccessControl, Pausable, ERC20Capped {
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

  constructor (address _minter, address _burner, uint256 _cap) ERC20Capped(_cap) ERC20("MyToken", "MTK")  {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _setupRole(MINTER_ROLE, _minter);
    _setupRole(BURNER_ROLE, _burner);
  }
  

  function mint(address to, uint256 amount) external whenNotPaused {
    require(hasRole(MINTER_ROLE, msg.sender), "Require role to be Minter");
    super._mint(to, amount);
  }

  function burn (address from, uint256 amount) external whenNotPaused {
    require(hasRole(BURNER_ROLE, msg.sender), "Require role to be Burnable");
    super._burn(from, amount);
  }
  
  function pause() external {
      require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Require role to be Owner");
      super._pause();
  }
  
  
  function unpause() external {
      require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Require role to be Owner");
      super._unpause();
  }
}
