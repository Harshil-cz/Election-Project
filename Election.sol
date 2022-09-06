// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Election {
    address public Election_Comissioner;
    address payable[] public Participants;
    mapping (address=>bool) verify_Participants;
    address[] public voters;
    mapping(address=>bool) verify_voters;
    uint public No_of_vote_P1;
    uint public No_of_vote_P2;

    // Declare Election Comissioner
    constructor(){
       Election_Comissioner=msg.sender; 
    }

    // Become a Participant
    receive() external payable {
        require(msg.sender!=Election_Comissioner,"You can not Participate.");
        require(verify_Participants[msg.sender]==false,"You have already participated");
        require(Participants.length<2,"Participants limit reached.");
        require(msg.value==5 ether,"Minimum 2 eher require to participate in Election.");
        Participants.push(payable(msg.sender));
        verify_Participants[msg.sender]=true; 
    }

    // Check Contract Balance
    function Get_Balance() public view returns(uint){
        require(msg.sender==Election_Comissioner,"Only Election Comissioner can access the Balance");
        return address(this).balance;
    }

    // vote to Participant-1
    function vote_p1() public{
        require(Participants.length==2,"There is not enough participants.");
        require(verify_voters[msg.sender]==false,"you have already voted.");
        No_of_vote_P1++;
        voters.push(msg.sender);
        verify_voters[msg.sender]=true;
    }  

    // vote to Participant-2
    function vote_p2() public{
        require(Participants.length==2,"There is not enough participants.");
        require(verify_voters[msg.sender]==false,"you have already voted.");
        No_of_vote_P2++;
        voters.push(msg.sender);
        verify_voters[msg.sender]=true;
    }

    // Check voters have been voted or not
    function check() public view returns(bool){
        bool i;
        i=verify_voters[msg.sender];
        return i;
    }

    // Calculate total number of voters
    function total_voters() public view returns(uint){
        uint num;
        num=voters.length;
        return num;
    } 

    // Declare the Winner of Election
    function Winner() public view returns(address){
        require(msg.sender==Election_Comissioner,"Only Election Commisioner can declare the winner");
        require(No_of_vote_P1>No_of_vote_P2||No_of_vote_P1<No_of_vote_P2,"Both Candidate get Equal votes, so Re-voting is required.");
        
        address temp;
        if(No_of_vote_P1>No_of_vote_P2){
            temp=Participants[0];
        }
        else{
            temp=Participants[1];
        } 
        return temp;
    }

    // Pay Contarct balance to Election Winner
    function pay_to_Winner() public{
        require(msg.sender==Election_Comissioner,"Only Election Comissioner have rights to pay winner.");
        payable(Winner()).transfer(Get_Balance());
    }
    
}

contract A is Election{}

contract B is Election{}

contract C is Election{}
