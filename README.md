# grille (gem / heavy WIP)
Rails engine that utilizes VueJS and GraphQl to create a generalized grid component/interface

## Goal

- create gem that provides user authentication and grid ui for viewing model data
- provide permission system to protect model CRUD operations
- have a simple interface for extending the base application and grid features

## Info

- uses `devise` and `devise-jwt` for JWT token based authentication with user model
- leverages `graphql` for model CRUD operation interface
- components made using `VueJS`, `Vuetify`, and `agGrid`

![](https://i.imgur.com/pI3dW9C.png)

## TODO

- DRY
- begin adding specs for regression testing and future features
- add permission system (add to jwt payload?)
- create npm package for Grid component
- remove unused files (files from generators)
