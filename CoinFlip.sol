//SPDX-License_Identifier: MIT
pragma solidity >=0.8.0;

contract CoinFlip {
    //player1 makes bet and flip coin
    //player2 takes bet and guess coin
    //player1 reveals coin and bet is settled

    address public player1; 
    address public player2;
    byte32 public player1Commit; //Bool (heads or tails)
    bool public player2Choice; //Bool
    uint256 public betAmount;
    uint256 public expiration = 2**256 - 1;


    function makeBet(byte32 commit) public payable{
        player1 = msg.sender;
        player1Commit = commit;
        betAmount = msg.value;
    }

    function cancel() public {
        require(msg.sender == player1);
        require(player2 == 0);
        betAmount = 0;
        msg.sender.transfer(address(this).balance);
    }

    function takeBet(choice) public payable {
        require(player2 == 0); //no other account has taken bet
        require(betAmount == msg.value);
        player2 = msg.sender;
        player2Choice = choice;
        expiration = now + 2 hours;
    }

    function reveal(bool choice, uint256 nonce) public {
        require(player2 !=0); //make sure someone is on the other end
        require(now < expiration); //make sure player1 reveals on time
        require(keccak256(choice, nonce) == player1Commit);

        if (player2Choice == choice) {
            player2.transfer(address(this).balance);
        }
        else {
            player1.transfer(address(this).balance);
        }
    }

    function timeout() public {
        require(player2 != 0);
        require(now > expiration);
        player2.transfer(address(this).balance);
    }

}