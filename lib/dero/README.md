# Dero

Heavily inspired by works of Sentry's Raven. It attempts to be practical,
less bloated, and try to integrate with most popular frameworks only.

## The folders and what they mean

| folder | meaning
| ------ | --------
| integrations | Engines (eg. Rack, Rails, Sidekiq) on which Dero will try to integrate itself automagically
| processor | Data pipelines, eg: cookies manipulator, etc.
| reporter | Core of data sending to Dero's server
| kernel | Other important files which cannot be put in other folders above, to keep subgem's root directory really clean from implementations
