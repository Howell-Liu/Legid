

module legIDModule::main {

    use std::string;
    use std::vector;

    use sui::url::{Self, Url};
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    resource Addresses {
        addresses: vector<address>;
    }

    // structure to show the status of the NFT, whether it is in the process of being sold or not
    struct transitStatus {
        in_transit : bool, // boolean of whether the nft is in transit
        pending_buyer: address // if in_transit, pending_buyer = buyer's address, otherwise blank address of 0x0
    }

    struct legIdNft has key{
        //nft_id = something to identify the initial nft, whether it be a hash or w/e
            /*
            use number:: u64;
            use name:: string::String;
            use capacity:: u64;
            */
        
        id : UID,
        transit_status : transitStatus, // 
        block_stamp: u64, // block number correlating to transaction. block number has date
        collection_number: u64,
        name: string::String,
        current_owner : address, //null address
        transaction_history : vector<u8>, // the hash of the last state of the nft
        original_minter : address // the address of the manufacturer
    }

    public fun create_NFT(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ){
        // Intake: product_unique_info, manufacturer address
            // ASSERTS tx.sender is in list of Verified Manufacturers
        // Purpose: create an object and transfer it to the tx.sender
        // Output: NFT formed
            // in_transit initialized as 0
            // current_owner and original_minter set as the one who call create_NFT
            // hash transaction_history = 0x0 (empty hash)
            // the product unique info is loaded with w/e info the creator wants to put in
        // Person working on this:
        // Expected time: 1 hour
        //TODO 
        
        let sender = tx_context::sender(ctx);
        
        let found = false;

        for addr in addresses {
            if addr == sender {
                found = true;
                break;
            }
        }

        assert!(found, 0);

        let init_transit_status = transitStatus {
            in_transit : false,
            pending_buyer: 0x0
        }

        let nft = legIdNft {
            id: object::new(ctx),
            in_transit: false,
            block_stamp: 420,
            collection_number: 12,
            current_owner : sender,
            transaction_history : []
        };

        transfer::public_transfer(nft, sender);

    //     struct legIdNft {
    //     //nft_id = something to identify the initial nft, whether it be a hash or w/e
    //         /*
    //         use number:: u64;
    //         use name:: string::String;
    //         use capacity:: u64;
    //         */
        
    //     id : UID,
    //     in_transit : bool, // maybe have this as a blank address or an interested owner address
    //     block_stamp: u64,
    //     collection_number: u64,
    //     name: string::String,

    //         // false: not in limbo
    //         // true: in limbo 
    //     current_owner : address, //null address
    //     // hash transaction_history = 
    //     // original_minter = 0x0; //null address
    //     //

    // }
        
    } 

    public fun manufacturer_add(manufacturer : address, 
                                company_name : vector<u8>, 
                                ctx : &mut TxContext) {

        let sender = tx_context::sender(ctx);

        let found = false;

        for addr in  {
            if addr == sender {
                found = true;
                break;
        }

        assert!(found, 0);
        // Intake: company_name, wallet public address
            // ASSERTS tx.sender is a verified admin address
        // Purpose: adds verified manufacturer to list and makes an ID
        // Output: hash_ID_manufacturer. We expect the manufacturer to make this address public, and that other people can't login. We can store a list of these
        // Person working on this:
        // Expected time:
    }

    public fun validate() :: bool{
        // Intake: nft, product_unique_info, current_owner_address, manufacturer ID
        // Purpose: checks that the seller initating the transfer is the current owner of the nft
            // that the manufacturer ID matches that of the NFT minter
        // Output: true if the transaction is valid for the buyer
        // Person working on this:
        // Expected time:
    }
    
    /*
    Transfer Accepted Algorithm
    initially hash_transaction_history = 0x0
    Upon transfer_accept():
    - the hash of the nft struct is stored as the new hash_transaction_history
    - the current_owner = init_transfer (address of the pending buyer)
    - the init_transfer = 0x0
    */

    public fun transfer_initiate() {
        // Intake: buyer_address, nft, seller_address
            // ASSERTS tx.initiator is current owner of nft
        // Purpose: to initiate the transfer by the current owner
        // Output: sets the nft in 'in_transit' mode, where the nft can only be accepted or cancelled
        // Person working on this:
        // Expected Time:
    }

    public fun transfer_accept() {
        // Intake: nft, buyer_address
            // ASSERTS tx.acceptor is the listed acceptor of the initated transfer
            // ASSERTS validate() 
            // ASSERTS in_transit is true
        // Purpose: to end the transfter
        // Output: nft object is updated to reflect the transfer
        // Person working on this:
        // Expected Time:
    }

    public fun transfer_cancel() {
        // Intake: nft
        // Purpose: to cancel the transfer from either the buyer or seller side
            // buyer can cancel the transfer if deemed fake, asserts that buyer matches in_transit
            // seller can cancel the transfer if they reject the sale, asserts seller matches owner_id
        // Output: nft with state changed, in_transit = 0x0
        // Person working on this:
        // Expected Time:
    }

}

}

// create struct, define ownership of srtruct, 

// Intake: 
// Purpose:
// Output:
// Person working on this:
// Expected Time:
