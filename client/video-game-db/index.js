import('./src/App.elm').then(Elm => {
    var mountNode = document.getElementById('main');
    var app = Elm.App.embed(mountNode);

    app.ports.setPageTitle.subscribe(title => {
        document.title = title;
    });
});
