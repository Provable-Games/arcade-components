import { gql } from "@apollo/client";

const getTournamentModels = gql`
  query {
    tournamentTournamentModelModels {
      edges {
        node {
          tournament_id
          creator
          start_time
          end_time
          entry_premium {
            option
            Some {
              token
              token_distribution
              token_amount
              creator_fee
            }
          }
          gated_type {
            option
            Some {
              option
              token {
                token
                entry_type {
                  uniform
                  criteria {
                    token_id
                    entry_count
                  }
                  option
                }
              }
              address
              tournament
            }
          }
        }
      }
    }
  }
`;

export { getTournamentModels };
