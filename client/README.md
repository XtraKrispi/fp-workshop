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
   
   My suggestion is to change the setting `elm.formatOnSave` to `true` in Preferences

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
