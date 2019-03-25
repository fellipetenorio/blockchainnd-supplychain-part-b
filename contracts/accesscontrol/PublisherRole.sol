pragma solidity ^0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'PublisherRole' to manage this role - add, remove, check
contract PublisherRole {
  
  // Define 2 events, one for Adding, and other for Removing

  // Define a struct 'Publishers' by inheriting from 'Roles' library, struct Role

  // In the constructor make the address that deploys this contract the 1st Publisher
  constructor() public {

  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyPublisher() {

    _;
  }

  // Define a function 'isPublisher' to check this role
  function isPublisher(address account) public view returns (bool) {

  }

  // Define a function 'addPublisher' that adds this role
  function addPublisher(address account) public onlyPublisher {

  }

  // Define a function 'renouncePublisher' to renounce this role
  function renouncePublisher() public {

  }

  // Define an internal function '_addPublisher' to add this role, called by 'addPublisher'
  function _addPublisher(address account) internal {

  }

  // Define an internal function '_removePublisher' to remove this role, called by 'removePublisher'
  function _removePublisher(address account) internal {

  }
}