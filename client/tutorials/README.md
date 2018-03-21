Functional Programming Workshop Client Application
==================================================

Prerequisites
=============

1) **Node.js and NPM/Yarn**

   Nodejs and npm installer can be found here: https://nodejs.org/

   Yarn can be found here: https://yarnpkg.com/en/
2) **Elm**

   Install elm via:

     npm: `npm install -g elm`

     yarn: `yarn global add elm`

Nice to haves
=============
1) **elm-format**

   npm: `npm install -g elm-format`

   yarn: `yarn global add elm-format`

2) **Visual Studio Code**
   Install from here: https://code.visualstudio.com/
3) **elm VSCode extension**
   Can be installed from the extensions pane

   OR

2) **Atom**
   Install from here: https://atom.io/
3) **Packages for Atom**
   Follow the instructions here: https://medium.com/@kana_sama/elm-atom-9c6c2383fd04

My preferred setup at this point is with Atom as it seems to provide a superior
ide-like environment with Go To Definition support, auto formatting, linting on the 
fly (no saving required), full autocomplete and more.

Getting Started
===============

Once you have Elm and npm/yarn installed, simply run

`npm install` or `yarn` in the `client` directory to install any dependencies

There may be an issue with Permissions when running this command.  If you have problems, we've fixed this by running
`npm cache clean --force` and rerunning `npm install`

After they are installed, run the intro application:

`npm run intro` or `yarn intro`

This will start up a web server at port 3000 that is watching the source tree
for changes and will automatically reload your browser on file changes.
