# Client Manager

This is a dojo component that enables tracking of multiple game clients across different games.

The data tracked includes:
- Name
- URL
- Play count
- Rating

An NFT is minted for each client which is tracked and the address helt receives the stream of client rewards.

The Client Component should keep track of how many times a wallet has played a particular client and only allow it to rate the client per number of times played. Restricting each wallet to only voting once is futile as this would be easily circumvented by creating lots of wallets.