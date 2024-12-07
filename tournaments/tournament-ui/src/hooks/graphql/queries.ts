import { gql } from "@apollo/client";

const ADVENTURER_FIELDS = `
  id
  owner
  entropy
  name
  health
  strength
  dexterity
  vitality
  intelligence
  wisdom
  charisma
  luck
  xp
  weapon
  chest
  head
  waist
  foot
  hand
  neck
  ring
  beastHealth
  statUpgrades
  birthDate
  deathDate
  goldenTokenId
  customRenderer
  battleActionCount
  gold
  createdTime
  lastUpdatedTime
  timestamp
`;

const ADVENTURERS_FRAGMENT = `
  fragment AdventurerFields on Adventurer {
    ${ADVENTURER_FIELDS}
  }
`;

const GOLDEN_TOKEN_FIELDS = `
  contract_address
  id
  image
  name
  owner
  token_id
`;

const GOLDEN_TOKEN_FRAGMENT = `
  fragment GoldenTokenFields on ERC721Tokens {
    ${GOLDEN_TOKEN_FIELDS}
  }
`;

const getAdventurerById = gql`
  ${ADVENTURERS_FRAGMENT}
  query get_adventurer_by_id($id: FeltValue) {
    adventurers(where: { id: { eq: $id } }) {
      ...AdventurerFields
    }
  }
`;

const getAdventurersInList = gql`
  ${ADVENTURERS_FRAGMENT}
  query get_adventurer_by_id($ids: [FeltValue!]) {
    adventurers(where: { id: { In: $ids } }, limit: 10) {
      ...AdventurerFields
    }
  }
`;

const getGoldenTokensByOwner = gql`
  ${GOLDEN_TOKEN_FRAGMENT}
  query getGoldenTokensByOwner($contractAddress: String!, $owner: String!) {
    getERC721Tokens(
      contract_address: $contractAddress
      cursor: 0
      limit: 101
      owner: $owner
    ) {
      ...GoldenTokenFields
    }
  }
`;

export { getAdventurerById, getAdventurersInList, getGoldenTokensByOwner };
