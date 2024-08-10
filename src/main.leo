// The 'aleoworkshop_ist_token_example' program.
program aleoworkshop_ist_token_example.aleo {
    mapping accounts : address => u64;

    record token {
        owner: address,
        amount: u64,
    }

    async transition mint_public( public receiver: address, public amount: u64) -> Future {
        return finalize_mint_public(receiver, amount);
    }

    async function finalize_mint_public(public receiver: address, public amount: u64) {
        let current_amount: u64 = Mapping::get_or_use(accounts, receiver, 0u64);
        Mapping::set(accounts, receiver, amount + current_amount);
    }

    transition mint_private (receiver:address, public amount:u64) -> token {
        return token {
            owner:receiver,
            amount:amount
        };
    }

    async transition transfer_public(public receiver:address, public amount: u64) -> Future {
        return update_transfer_public(self.caller, receiver, amount);
    }

    async function update_transfer_public(public sender: address, public receiver:address, public amount:u64) {
        let sender_amount: u64 = Mapping::get_or_use(accounts, sender, 0u64);
        Mapping::set(accounts, sender, sender_amount - amount);

        let receiver_amount: u64 = Mapping::get_or_use(accounts, receiver, 0u64);
        Mapping::set(accounts, receiver, receiver_amount + amount);
    }

    transition transfer_private(sender_token: token, receiver:address, amount:u64) -> (token, token) {
        let remaining_balance: u64 = sender_token.amount - amount;

        let remaining_token: token = token {
            owner: sender_token.owner,
            amount: remaining_balance
        };

        let transferred_token: token = token {
            owner: sender_token.owner,
            amount: remaining_balance
        };

        return (remaining_token, transferred_token);
    }

    async transition transfer_private_to_public(sender_token:token, public receiver:address, public amount:u64) -> (token, Future) {
        let remaining_balance: u64 = sender_token.amount - amount;

        let remaining_token: token = token {
            owner: sender_token.owner,
            amount: remaining_balance
        };

        return (remaining_token, finalize_transfer_private_to_public(receiver, amount));
    }

    async function finalize_transfer_private_to_public(public receiver:address, public amount: u64) {
        let current_amount: u64 = Mapping::get_or_use(accounts, receiver, 0u64);
        Mapping::set(accounts, receiver, amount + current_amount);
    }

    async transition transfer_public_to_private(receiver:address, public amount: u64) -> (token, Future) {
        let token: token = token {
            owner: receiver,
            amount: amount
        };

        return (token, finalize_transfer_public_to_private(self.caller, amount));
    }

    async function finalize_transfer_public_to_private(public sender:address, public amount:u64) {
        let current_amount: u64 = Mapping::get_or_use(accounts, sender, 0u64);
        Mapping::set(accounts, sender, amount - current_amount);
    }
}
