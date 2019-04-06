pragma solidity ^0.5.2;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'WriterRole' to manage this role - add, remove, check
contract WriterRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event WriterAdded(address indexed account);
  event WriterRemoved(address indexed account);

  // Define a struct 'Writers' by inheriting from 'Roles' library, struct Role
  Roles.Role private Writers;

  // In the constructor make the address that deploys this contract the 1st Writer
  constructor() public {
    _addWriter(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyWriter() {
    require(isWriter(msg.sender), "Need to be a Writer");
    _;
  }

  // Define a function 'isWriter' to check this role
  function isWriter(address account) public view returns (bool) {
    return Writers.has(account);
  }

  // Define a function 'addWriter' that adds this role
  function addWriter(address account) public onlyWriter {
    _addWriter(account);
  }

  // Define a function 'renounceWriter' to renounce this role
  function renounceWriter() public {
    _removeWriter(msg.sender);
  }

  // Define an internal function '_addWriter' to add this role, called by 'addWriter'
  function _addWriter(address account) internal {
    Writers.add(account);
    emit WriterAdded(account);
  }

  // Define an internal function '_removeWriter' to remove this role, called by 'removeWriter'
  function _removeWriter(address account) internal {
    Writers.remove(account);
    emit WriterRemoved(account);
  }
}