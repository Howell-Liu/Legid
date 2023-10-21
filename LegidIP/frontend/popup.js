import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';

EXAMPLE_OBJECT_HASH = '0x1234567890'

const client = new SuiClient({ url: getFullnodeUrl('localnet') });

function getObject(object = EXAMPLE_OBJECT_HASH) {
    client.getObject()
}


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


function popup(nftUrl) {
    var image = displayLogo('legid.png');
    var text = NFTinfoDisplay("info");
    document.body.appendChild(image);
    document.body.appendChild(text);
    // const popup = document.getElementById("popup");
    return image;
}

function NFTinfoDisplay(info ) {
    
}


popup('legid.png');

