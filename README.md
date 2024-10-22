# Arcade Components

## Overview

This repo contains dojo-compatible cairo components that can be used to build a permissionlessly expandable game world. The top-level component is the Creator Registration Component which everything else depends on. Once a creator has been registered in the world, other things can be added such as Items, Characters, Settings, Games, and custom Game Clients.

We are actively developing a DOJO-compatible ERC721 component which will be contributed to [Origami](https://github.com/dojoengine/origami) (an open-source dojo library). The significance of a DOJO-compatible ERC721 component is that it enables DOJO-compatible Components to leverage [Open Zeppelins ERC721 Cairo implementation](https://github.com/OpenZeppelin/cairo-contracts/tree/main/src/token/erc721)

The components are isolated for separate functions:
- Creator Registration (available)
- Client Registration (available)
- Tournaments (coming soon)
- Item Registration (coming soon)
- Character Registration (coming soon)
- Setings Registration (coming soon)
- Game Registration (coming soon)