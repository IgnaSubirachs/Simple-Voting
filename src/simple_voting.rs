#![no_std]

multiversx_sc::imports!();
multiversx_sc::derive_imports!();

#[multiversx_sc::contract]
pub trait SimpleVoting {

    // ======================
    //   INIT
    // ======================

    /// Initializes the voting contract with a fixed bet price
    /// and a list of options.
    #[init]
    fn init(
        &self,
        bet_price: BigUint,
        options: MultiValueEncoded<ManagedBuffer>,
    ) {
        let caller = self.blockchain().get_caller();
        self.owner().set(&caller);
        self.is_open().set(true);
        self.bet_price().set(&bet_price);

        let mut options_mapper = self.options();
        let mut votes_mapper = self.votes();

        let mut count: usize = 0;

        for opt in options.into_iter() {
            require!(!opt.is_empty(), "Option text cannot be empty");

            options_mapper.set(count, &opt);

            let zero = BigUint::zero();
            votes_mapper.set(count, &zero);

            count += 1;
        }

        require!(count >= 2, "At least two options are required");
    }

    // ======================
    //   ENDPOINTS
    // ======================

    /// User votes for a given option index.
    /// - voting must be open
    /// - address can only vote once
    #[endpoint(vote)]
    fn vote(&self, option_index: usize) {
        require!(self.is_open().get(), "Voting is closed");

        let caller = self.blockchain().get_caller();

        // Check if this address already voted
        let voted_mapper = self.has_voted(&caller);
        let already_voted = if voted_mapper.is_empty() {
            false
        } else {
            voted_mapper.get()
        };
        require!(!already_voted, "Address has already voted");

        // Check option index
        let options_count = self.options().len();
        require!(option_index < options_count, "Invalid option index");

        // Increase votes for this option
        let mut votes_mapper = self.votes();
        let mut current_votes = votes_mapper.get(option_index);
        current_votes += BigUint::from(1u32);
        votes_mapper.set(option_index, &current_votes);

        // Mark address as having voted
        voted_mapper.set(true);

        // Emit event
        self.vote_cast_event(&caller, option_index, &current_votes);
    }

    /// Only owner can close the voting.
    #[endpoint(closeVoting)]
    fn close_voting(&self) {
        self.require_owner();
        self.is_open().set(false);
    }

    // ======================
    //   VIEWS
    // ======================

    #[view(getOwner)]
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress>;

    #[view(isOpen)]
    #[storage_mapper("is_open")]
    fn is_open(&self) -> SingleValueMapper<bool>;

    #[view(getOptions)]
    #[storage_mapper("options")]
    fn options(&self) -> VecMapper<ManagedBuffer>;

    /// Returns all votes as a list of BigUint (one per option, ordered).
    #[view(getVotes)]
    fn get_votes_view(&self) -> MultiValueEncoded<BigUint> {
        let mut result = MultiValueEncoded::new();
        let votes_mapper = self.votes();
        let len = votes_mapper.len();

        for i in 0..len {
            result.push(votes_mapper.get(i));
        }

        result
    }

    /// Returns the fixed bet price (per vote/bet).
    #[view(getBetPrice)]
    #[storage_mapper("bet_price")]
    fn bet_price(&self) -> SingleValueMapper<BigUint>;

    // ======================
    //   STORAGE
    // ======================

    #[storage_mapper("votes")]
    fn votes(&self) -> VecMapper<BigUint>;

    #[storage_mapper("has_voted")]
    fn has_voted(&self, addr: &ManagedAddress) -> SingleValueMapper<bool>;

    // ======================
    //   INTERNAL
    // ======================

    fn require_owner(&self) {
        let caller = self.blockchain().get_caller();
        require!(caller == self.owner().get(), "Only owner can call this endpoint");
    }

    // ======================
    //   EVENTS
    // ======================

    #[event("vote_cast")]
    fn vote_cast_event(
        &self,
        #[indexed] voter: &ManagedAddress,
        #[indexed] option_index: usize,
        new_total_for_option: &BigUint,
    );
}
