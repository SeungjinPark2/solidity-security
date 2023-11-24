
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/DelegateCall/Case2.sol";

contract DelegateCallTest2 is Test {
    Lib lib;
    Dao dao;
    Attack attack;

    function setUp() public {
        lib = new Lib();
        vm.prank(address(123));
        dao = new Dao(address(lib));
        vm.prank(address(456));
        attack = new Attack(payable(address(dao)));
    }

    function test_changeDaoOwner() public {
        attack.exploit();
        console.logAddress(dao.owner());
        console.logAddress(address(attack));
        assertEq(dao.owner(), address(attack));
    }
}
