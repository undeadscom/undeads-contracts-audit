const Router = artifacts.require('Router');
const Rights = artifacts.require('Rights');

module.exports = async function(callback) {
    try {
        const routerAddress = process.env.ROUTER;
        const router = await Router.at(routerAddress);
        const rightsAddress = await router.getAddress("Rights");
        const rights = await Rights.at(rightsAddress);
    
        const latestBlock = await web3.eth.getBlockNumber();

        let events = [];
        const chunkSize = 100000;
        for (let i = 0; i < latestBlock; i += chunkSize) {
            const adminDefinedEvents = await rights.getPastEvents('AdminDefined', {
                filter: { },
                fromBlock: i,
                toBlock: i + chunkSize
            });
    
            const adminClearedEvents = await rights.getPastEvents('AdminCleared', {
                filter: { },
                fromBlock: i,
                toBlock: i + chunkSize
            });
    
            events = events.concat(adminDefinedEvents.concat(adminClearedEvents)
                .sort(function(a, b) {
                    let x = a.blockNumber; 
                    let y = b.blockNumber;
                    if (x == y) {
                        x = a.logIndex;
                        y = b.logIndex;
                    }
                    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                }));
        }

        const admins = {};
        for (let i = 0; i < events.length; ++i) {
            let event = events[i];
            let contract = event.args.contractHash;
            let admin = event.args.admin;

            if (!admins[contract]) {
                admins[contract] = new Set();   
            }

            if (event.event == 'AdminDefined') {
                admins[contract].add(admin);
            } else if (event.event == 'AdminCleared') {
                admins[contract].delete(admin);
            }            
        }

        console.log("Admins by contract:");
        console.log(JSON.stringify(
            admins, 
            (_, value) => (value instanceof Set ? [...value] : value), 
            2)
        );
        
    } catch (e) {
        callback(e);
    }
    callback();
}