import '../css/app.css';
import { App } from './App.elm';
import registerServiceWorker from './registerServiceWorker';

var app = App.embed(document.getElementById('root'));

app.ports.setPageTitle.subscribe(title => {
  document.title = title;
});

registerServiceWorker();
