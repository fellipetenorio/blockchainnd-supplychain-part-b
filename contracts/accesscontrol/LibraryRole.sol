pragma solidity ^0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'LibraryRole' to manage this role - add, remove, check
contract LibraryRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event LibraryAdded(address indexed account);
  event LibraryRemoved(address indexed account);
  
  // Define a struct 'Librarys' by inheriting from 'Roles' library, struct Role
  Roles.Role private Libraries;

  constructor() public {
    _addLibrary(msg.sender)ç
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyLibrary() {
    require(isLibrary(msg.sender));
    _;
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier libraryOwner(address account) {
    require(isLibrary(account), "Not a Library Account");
    _;
  }

  // Define a function 'isLibrary' to check this role
  function isLibrary(address account) public view returns (bool) {
    return Libraries.has(account);
  }

  // Define a function 'addLibrary' that adds this role
  function addLibrary(address account) public onlyLibrary {
    _addLibrary(account);
  }

  // Define a function 'renounceLibrary' to renounce this role
  function renounceLibrary() public {
    _removeLibrary(msg.sender);
  }

  // Define an internal function '_addLibrary' to add this role, called by 'addLibrary'
  function _addLibrary(address account) internal {
    Libraries.add(account);
    emit LibraryAdded(account);
  }

  // Define an internal function '_removeLibrary' to remove this role, called by 'removeLibrary'
  function _removeLibrary(address account) internal {
    Libraries.remove(account);
    emit LibraryRemoved(account);
  }
}