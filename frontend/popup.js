// import { getFullnodeUrl, SuiClient } from './node_modules/@mysten/sui.js/client';

// EXAMPLE_OBJECT_HASH = '0x1234567890'

// const client = new SuiClient({ url: getFullnodeUrl('localnet') });

// function getObject(object = EXAMPLE_OBJECT_HASH) {
//     client.getObject(object);
// }


function displayNFT(url) {
    const img = document.createElement("img");
    img.src = url;
    img.setAttribute("class", "img-nft");
    return img;
}

function displayLogo(url) {
    const img = document.createElement("img");
    img.src = url;
    img.setAttribute("class", "img-logo");
    return img;
}


function item_profile_popup(nftUrl) {
    console.log("1.")
    var logo = displayLogo('legid.png');
    console.log("2.")
    // var text = NFTinfoDisplay("info");
    document.body.appendChild(logo);
}

// Pass nftInfo as a list of object with each object being of the same type as 

function profile_popup(nftInfo) {

    var logo = displayLogo('legid.png');
    document.body.appendChild(logo);
}

function NFTinfoDisplay(info ) {
    // function convert() {
        
    // }
}


item_profile_popup('legid.png');

