pragma solidity ^0.5.2;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'ReviewerRole' to manage this role - add, remove, check
contract ReviewerRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event ReviewerAdded(address indexed account);
  event ReviewerRemoved(address indexed account);

  // Define a struct 'Reviewers' by inheriting from 'Roles' library, struct Role
  Roles.Role private Reviewers;

  // In the constructor make the address that deploys this contract the 1st Reviewer
  constructor() public {
    _addReviewer(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyReviewer() {
    require(isReviewer(msg.sender));
    _;
  }

  // Define a function 'isReviewer' to check this role
  function isReviewer(address account) public view returns (bool) {
    return Reviewers.has(account);
  }

  // Define a function 'addReviewer' that adds this role
  function addReviewer(address account) public onlyReviewer {
    _addReviewer(account);
  }

  // Define a function 'renounceReviewer' to renounce this role
  function renounceReviewer() public {
    _removeReviewer(msg.sender);
  }

  // Define an internal function '_addReviewer' to add this role, called by 'addReviewer'
  function _addReviewer(address account) internal {
    Reviewers.add(account);
    emit ReviewerAdded(account);
  }

  // Define an internal function '_removeReviewer' to remove this role, called by 'removeReviewer'
  function _removeReviewer(address account) internal {
    Reviewers.remove(account);
    emit ReviewerRemoved(account);
  }
}