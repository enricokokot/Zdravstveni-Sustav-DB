import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import 'bootstrap/dist/css/bootstrap.css';
// import Counters from './components/counters';
// import {Button} from './components/counter';
// import 'jquery/dist/jquery.js';
// import 'popper.js/dist/umd/popper.js';
// import 'boostrap/dist/js/bootstrap.js';
ReactDOM.render(
    <App />,
    document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();