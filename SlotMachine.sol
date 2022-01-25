//SPDX-License_Identifier: MIT
pragma solidity >=0.8.0;

contract SlotMachine {
    //player makes bet and spins
    //spin will randomly pick three numbers (out of 7)
    //payout depending on results

    address public player;
    address payable owner;
    uint256 public betAmount;
    uint256 public slot1;
    uint256 public slot2;
    uint256 public slot3;
    uint256 public counter = 35;

    constructor() {
        owner = payable(msg.sender);
    }

    function makeBet(uint256 nonce) public payable {
        player = msg.sender;
        betAmount = msg.value;
        counter++;
        slot1 = (keccak256(abi.encodePacked(nonce, counter, block.timestamp)) % 7) + 1;
        counter++;
        slot2 = (keccak256(abi.encodePacked(nonce, slot1, counter, block.timestamp)) % 7) + 1;
        counter++;
        slot3 = (keccak256(abi.encodePacked(nonce, slot2, counter, block.timestamp)) % 7) + 1;  
        payOut();
    }

    function payOut() public payable {
        if (slot1 == 7 && slot2 == 7 && slot3 == 7){
            //7x payout
            player.trasnfer(7.0 * address(this).balance);
        }
        else if (slot1 == slot2 == slot3) {
            // 2x payout
            player.trasnfer(2.0 * address(this).balance);
        }
        else if(slot1 == slot2 || slot2 == slot3 || slot1 == slot3) {
            //.5x payout
            player.trasnfer(0.5 * address(this).balance);
        }
        else {
            owner.call{value: msg.value}("");
        }
    }

}