pragma solidity ^0.4.17;

contract RPS {
    
    mapping(string => mapping(string => int)) payoffMatrix;
    address public player1;
    address public player2;
    string public player1Choice;
    string public player2Choice;


    // Modifiers can be used to change
    // the body of a function.
    // If this modifier is used, it will
    // prepend a check that only passes
    // if the function is called from
    // a certain address.
    modifier notRegisteredYet() {
        require(msg.sender != player1 && msg.sender != player2);
        _;
    }
    
    modifier sentEnoughCash(uint amount) {
        require (msg.value == amount);
        _;
    }

    event Sent(address from, address to, uint amount);
    
    //Costructor
    function rps() public {
        payoffMatrix["rock"]["rock"] = 0;
        payoffMatrix["rock"]["paper"] = 2;
        payoffMatrix["rock"]["scissors"] = 1;
        payoffMatrix["paper"]["rock"] = 1;
        payoffMatrix["paper"]["paper"] = 0;
        payoffMatrix["paper"]["scissors"] = 2;
        payoffMatrix["scissors"]["rock"] = 2;
        payoffMatrix["scissors"]["paper"] = 1;
        payoffMatrix["scissors"]["scissors"] = 0;
    }
    

    function getWinner() public view returns (int x) {
        return payoffMatrix[player1Choice][player2Choice];
    }
    
    function play(string choice) public returns (int w) {
        if (msg.sender == player1)
            player1Choice = choice;
        else if (msg.sender == player2)
            player2Choice = choice;

        if (bytes(player1Choice).length != 0 && bytes(player2Choice).length != 0) {
            
            int winner = payoffMatrix[player1Choice][player2Choice];

            if (winner == 1) {
                Sent(player2, this, this.balance);
                //player1.send(this.balance);
            } else if (winner == 2) {
                Sent(player1, this, this.balance);
                //player2.send(this.balance);
            } else {
                Sent(player1, this, this.balance/2);
                Sent(player2, this, this.balance);
                //player1.send(this.balance/2);
                //player2.send(this.balance);
            }
             
            // unregister players and choices
            player1Choice = "";
            player2Choice = "";
            player1 = 0;
            player2 = 0;
            return winner;
        } else {
            return -1;
        }
    }
    
// HELPER FUNCTIONS (not required for game)

    function getMyBalance () view public returns (uint amount) {
        return msg.sender.balance;
    }
    
    function getContractBalance () view public returns (uint amount) {
        return this.balance;
    }
    
    function register() sentEnoughCash(5) notRegisteredYet() public {
        if (player1 == 0)
            player1 = msg.sender;
        else if (player2 == 0)
            player2 = msg.sender;
    }
    
    function AmIPlayer1() view public returns (bool x) {
        return msg.sender == player1;
    }
    
    function AmIPlayer2() view public returns (bool x) {
        return msg.sender == player2;
    }

    
    function checkBothNotNull() view public returns (bool x) {
        return (bytes(player1Choice).length == 0 && bytes(player2Choice).length == 0);
    }

// \HELPER FUNCTIONS

}