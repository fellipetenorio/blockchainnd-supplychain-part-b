pragma solidity ^0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'WriterRole' to manage this role - add, remove, check
contract WriterRole {

  // Define 2 events, one for Adding, and other for Removing

  // Define a struct 'Writers' by inheriting from 'Roles' library, struct Role

  // In the constructor make the address that deploys this contract the 1st Writer
  constructor() public {
    
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyWriter() {
    
    _;
  }

  // Define a function 'isWriter' to check this role
  function isWriter(address account) public view returns (bool) {
    
  }

  // Define a function 'addWriter' that adds this role
  function addWriter(address account) public onlyWriter {
    
  }

  // Define a function 'renounceWriter' to renounce this role
  function renounceWriter() public {
    
  }

  // Define an internal function '_addWriter' to add this role, called by 'addWriter'
  function _addWriter(address account) internal {
    
  }

  // Define an internal function '_removeWriter' to remove this role, called by 'removeWriter'
  function _removeWriter(address account) internal {
    
  }
}