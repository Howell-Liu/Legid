import { getFullnodeUrl, SuiClient } from './node_modules/@mysten/sui.js/client';

EXAMPLE_OBJECT_HASH = '0x1234567890';

const client = new SuiClient({ url: getFullnodeUrl('localnet') });

function getObject(object = EXAMPLE_OBJECT_HASH) {
    return client.getObject(object);
}

console.log(getObject());