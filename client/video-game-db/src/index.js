import '../css/app.css';
import { App } from './App.elm';
import registerServiceWorker from './js/registerServiceWorker';

var app = App.embed(document.getElementById('root'), { baseUrl: "http://localhost:1234/api/" });

app.ports.setPageTitle.subscribe(title => {
  document.title = title;
});

registerServiceWorker();
