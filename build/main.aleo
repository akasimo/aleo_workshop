program aleoworkshop_ist_token_example.aleo;

record token:
    owner as address.private;
    amount as u64.private;


mapping accounts:
	key as address.public;
	value as u64.public;


function mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    async mint_public r0 r1 into r2;
    output r2 as aleoworkshop_ist_token_example.aleo/mint_public.future;

finalize mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use accounts[r0] 0u64 into r2;
    add r1 r2 into r3;
    set r3 into accounts[r0];



function mint_private:
    input r0 as address.private;
    input r1 as u64.public;
    cast r0 r1 into r2 as token.record;
    output r2 as token.record;



function transfer_public:
    input r0 as address.public;
    input r1 as u64.public;
    async transfer_public self.caller r0 r1 into r2;
    output r2 as aleoworkshop_ist_token_example.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get.or_use accounts[r0] 0u64 into r3;
    sub r3 r2 into r4;
    set r4 into accounts[r0];
    get.or_use accounts[r1] 0u64 into r5;
    add r5 r2 into r6;
    set r6 into accounts[r1];



function transfer_private:
    input r0 as token.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as token.record;
    cast r0.owner r3 into r5 as token.record;
    output r4 as token.record;
    output r5 as token.record;



function transfer_private_to_public:
    input r0 as token.record;
    input r1 as address.public;
    input r2 as u64.public;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as token.record;
    async transfer_private_to_public r1 r2 into r5;
    output r4 as token.record;
    output r5 as aleoworkshop_ist_token_example.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use accounts[r0] 0u64 into r2;
    add r1 r2 into r3;
    set r3 into accounts[r0];




function transfer_public_to_private:
    input r0 as address.private;
    input r1 as u64.public;
    cast r0 r1 into r2 as token.record;
    async transfer_public_to_private self.caller r1 into r3;
    output r2 as token.record;
    output r3 as aleoworkshop_ist_token_example.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use accounts[r0] 0u64 into r2;
    sub r1 r2 into r3;
    set r3 into accounts[r0];

