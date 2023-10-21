

module legIDModule::main {

    use std::string;
    use std::vector;

    use sui::url::{Self, Url};
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    use sui::package;
    use sui::display;

    // resource Addresses {
    //     addresses: vector<address>;
    // }


    struct approvedManufacturers has key {
        uid : UID,
        listOfManufacturers : vector<address>,
        size : u64
    }

    // structure to show the status of the NFT, whether it is in the process of being sold or not
    struct transitStatus {
        in_transit : bool, // boolean of whether the nft is in transit
        pending_buyer: address // if in_transit, pending_buyer = buyer's address, otherwise blank address of 0x0
    }

    struct adminCapabilities has key {
        uid : UID,
    }

    struct manuCapabilities has key {
        uid : UID,
    }

    struct legIdNft has key, store{
        //nft_id = something to identify the initial nft, whether it be a hash or w/e
            /*
            use number:: u64;
            use name:: string::String;
            use capacity:: u64;
            */
        
        id : UID,
        transit_status : transitStatus, // 
        epoch_stamp: u64, // block number correlating to transaction. block number has date
        collection_number: u64,
        name: string::String,
        current_owner : address, //null address
        transaction_history : vector<u8>, // the hash of the last state of the nft
        original_minter : address // the address of the manufacturer
    }

    // public fun init(ctx: &mut TxContext) {
    //     transfer::share_object(approvedManufacturers{
    //         uid: object::new(ctx),
    //         listOfManufacturers: vector::empty<address>(),
    //         size : 0
    //     });

    //     transfer::transfer(adminCapabilities {
    //         uid: object::new(ctx)
    //     }, tx_context::sender(ctx));
    // }

    public fun create_NFT(
        _manuCap : manuCapabilities,
        _name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        _collection_number : u64,
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
        
        let sender = tx_context::sender(ctx);
        
        let init_transit_status = transitStatus {
            in_transit : false,
            pending_buyer: 0x0
        }

        let nft = legIdNft {
            name: string::utf8(_name),
            id: object::new(ctx),
            transit_status: init_transit_status,
            epoch_stamp: tx_context::epoch(ctx),
            collection_number: _collection_number,
            current_owner : sender,
            transaction_history : 0x0,
            original_minter: sender,
        };

        transfer::public_transfer(nft, sender);
        
    } 
    
    

    public fun manufacturer_add(_cap : &adminCapabilities,
                                manufacturer : address, 
                                company_name : vector<u8>, 
                                ctx : &mut TxContext) {

        let sender = tx_context::sender(ctx);

        transfer::transfer(manuCapabilities {
            uid: object::new(ctx)
        }, sender);

        // Intake: company_name, wallet public address
            // ASSERTS tx.sender is a verified admin address
        // Purpose: adds verified manufacturer to list and makes an ID
        // Output: hash_ID_manufacturer. We expect the manufacturer to make this address public, and that other people can't login. We can store a list of these
        // Person working on this:
        // Expected time:
    }

    public fun validate(
        nft: legIdNft,
        current_owner_address: address,
        manufacturer_address: address
    ) {
        // Intake: nft, product_unique_info, current_owner_address, manufacturer ID
        // Purpose: checks that the seller initating the transfer is the current owner of the nft
            // that the manufacturer ID matches that of the NFT minter
        // Output: true if the transaction is valid for the buyer
        // Person working on this:
        // Expected time:
        let validation = true;

        if (legIdNft.current_owner != current_owner_address) validation = false;

        if (legIdNft.original_minter != manufacturer_address) validation = false;

        validation // returns validation status
    }
    
    /*
    Transfer Accepted Algorithm
    initially hash_transaction_history = 0x0
    Upon transfer_accept():
    - the hash of the nft struct is stored as the new hash_transaction_history
    - the current_owner = init_transfer (address of the pending buyer)
    - the init_transfer = 0x0
    */

    public fun transfer_initiate(
        nft: legIdNft,
        buyer_address: address,
        ctx: &mut TxContext
    ) {
        // Intake: buyer_address, nft, seller_address
            // ASSERTS tx.initiator is current owner of nft
        // Purpose: to initiate the transfer by the current owner
        // Output: sets the nft in 'in_transit' mode, where the nft can only be accepted or cancelled
        // Person working on this:
        // Expected Time:
        let sender = tx_context::sender(ctx);
        
        if (sender != nft.current_owner) return false; // Asserts that transfer initiator is nft owner
        if (!nft.transit_status.in_transit) return false; // Asserts that transfer isn't already being transferred

        nft.transit_status.in_transit = true;
        nft.transit_status.pending_buyer = buyer_address;
        return true
    }

    public fun transfer_accept(
        nft: legIdNft,
        ctx: &mut TxContext,
        seller_address: address,
        manufacturer_address: address
    ) {
        // Intake: nft, buyer_address
            // ASSERTS tx.acceptor is the listed acceptor of the initated transfer
            // ASSERTS validate() 
            // ASSERTS in_transit is true
        // Purpose: to end the transfter
        // Output: nft object is updated to reflect the transfer
        let sender = tx_context::sender(ctx);

        // Asserts that the nft is in transit
        if (!nft.transit_status.in_transit) return false;

        // Asserts that transfer acceptor is nft pending buyer
        if (sender != nft.transit_status.pending_buyer) return false; 

        // Asserts that the product is valid
        if (!validate(nft, seller_address, manufacturer_address)) return false;

        let new_hash = sha3(nft)
    }

    public fun nft_to_string(
        nft: legIdNft
    ) {
        let 
    }

    public fun transfer_cancel(
        nft: legIdNft,
        ctx: &mut TxContext
    ) {
        // Intake: nft
        // Purpose: to cancel the transfer from either the buyer or seller side
            // buyer can cancel the transfer if deemed fake, asserts that buyer matches in_transit
            // seller can cancel the transfer if they reject the sale, asserts seller matches owner_id
        // Output: nft with state changed, in_transit = 0x0
        let sender = tx_context::sender(ctx);

        // sender must be either the seller or the pending buyer to cancel the transfer
        if (!((sender ==  legIdNft.current_owner) || (sender == legIdNft.transit_status.pending_buyer))) return false;

        legIdNft.transit_status.in_transit = false; // transit status set false
        legIdNft.transit_status.pending_buyer = 0x0; // pending_buyer address is blanked
    }

    // *** ---   TESTS   --- ***

    #[test]
    public fun test_create_nft() {
        use sui::test_scenario;

        // create test addresses representing users
        let admin = @0xBABE;
        let initial_owner = @0xCAFE;
        let final_owner = @0xFACE;

        // public fun manufacturer_add(_cap : &adminCapabilities,
        //                         manufacturer : address, 
        //                         company_name : vector<u8>, 
        //                         ctx : &mut TxContext)

        // first transaction to emulate module initialization
        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        {
            init(test_scenario::ctx(scenario));
        };
        // second transaction executed by admin to create the sword
        test_scenario::next_tx(scenario, admin);
        {
            // create the sword and transfer it to the initial owner
            let adminCap = test_scenario::take
            manufacturer_add()
        };
        // third transaction executed by the initial sword owner
        test_scenario::next_tx(scenario, initial_owner);
        {
            // extract the sword owned by the initial owner
            let sword = test_scenario::take_from_sender<Sword>(scenario);
            // transfer the sword to the final owner
            sword_transfer(sword, final_owner, test_scenario::ctx(scenario))
        };
        // fourth transaction executed by the final sword owner
        test_scenario::next_tx(scenario, final_owner);
        {
            // extract the sword owned by the final owner
            let sword = test_scenario::take_from_sender<Sword>(scenario);
            // verify that the sword has expected properties
            assert!(magic(&sword) == 42 && strength(&sword) == 7, 1);
            // return the sword to the object pool (it cannot be simply "dropped")
            test_scenario::return_to_sender(scenario, sword)
        };
        test_scenario::end(scenario_val);

    }

    
    // *** --- API LAYER --- ***

    struct OTW_legId_NFT has drop{}
    
    fun init(ctx: &mut TxContext){
        transfer::transfer(adminCapabilities {
            uid: object::new(ctx)
        }, tx_context::sender(ctx));
    }

    fun init_temp(otw: legIdNft, ctx: &mut TxContext) {

        transfer::transfer(adminCapabilities {
            uid: object::new(ctx)
        }, tx_context::sender(ctx));

        let keys = vector[
            utf8(b"id"),
            utf8(b"transit_status"),
            utf8(b"epoch_stamp"),
            utf8(b"collection_number"),
            utf8(b"current_owner"),
            utf8(b"transaction_history"),
            utf8(b"original_minter")
        ]

        let values = vector[
            utf8(b"{id}"),
            utf8(b"{transit_status}"),
            utf8(b"{epoch_stamp}"),
            utf8(b"{collection_number}"),
            utf8(b"{current_owner}"),
            utf8(b"{transaction_history}"),
            utf8(b"{original_minter}")
        ]

        let publisher = package::claim(otw, ctx);

        let display = display::new_with_fields<OTW_legId_NFT>(
            &publisher, keys, values, ctx
        );

        display::update_version(&mut display);

        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));

    }

}

// create struct, define ownership of srtruct, 

// Intake: 
// Purpose:
// Output:
// Person working on this:
// Expected Time:


//fun init(otw: MY_HERO, ctx: &mut TxContext) {
       // let keys = vector[
       //     utf8(b"name"),
       //     utf8(b"link"),
        //    utf8(b"image_url"),
        //    utf8(b"description"),
        //    utf8(b"project_url"),
        //    utf8(b"creator"),