function parseEvents(tx) {
    let outs=[];
    tx.logs.forEach(el => {
        if (outs[el.event]) {
            if (outs[el.event].isArray && outs[el.event].isArray()) {
                outs[el.event].push(el.args);
            } else {
                outs[el.event] = [outs[el.event], el.args];
            }
        } else {
            outs[el.event] = el.args;
        }
    });
    return outs;
};

module.exports = {
    parseEvents
};