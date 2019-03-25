pragma solidity ^0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'LibraryRole' to manage this role - add, remove, check
contract LibraryRole {

  // Define 2 events, one for Adding, and other for Removing
  
  // Define a struct 'Librarys' by inheriting from 'Roles' library, struct Role

  // In the constructor make the address that deploys this contract the 1st Library
  constructor() public {
    
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyLibrary() {
    
    _;
  }

  // Define a function 'isLibrary' to check this role
  function isLibrary(address account) public view returns (bool) {
    
  }

  // Define a function 'addLibrary' that adds this role
  function addLibrary(address account) public onlyLibrary {
    
  }

  // Define a function 'renounceLibrary' to renounce this role
  function renounceLibrary() public {
    
  }

  // Define an internal function '_addLibrary' to add this role, called by 'addLibrary'
  function _addLibrary(address account) internal {
    
  }

  // Define an internal function '_removeLibrary' to remove this role, called by 'removeLibrary'
  function _removeLibrary(address account) internal {
    
  }
}